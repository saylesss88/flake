# list all installed packages
def nix-list-system []: nothing -> list<string> {
  ^nix-store -q --references /run/current-system/sw
  | lines
  | filter { not ($in | str ends-with 'man') }
  | each { $in | str replace -r '^[^-]*-' '' }
  | sort
}

# upgrade system packages
def nix-upgrade [
  flake_path: string = "/home/jr/flake", # path that contains a flake.nix
  --interactive (-i) # select packages to upgrade interactively
]: nothing -> nothing {
  let working_path = $flake_path | path expand
  if not ($working_path | path exists) {
    echo "path does not exist: $working_path"
    exit 1
  }
  let pwd = $env.PWD
  cd $working_path
  if $interactive {
    let selections = nix flake metadata . --json
    | from json
    | get locks.nodes
    | columns
    | str join "\n"
    | fzf --multi --tmux center,20%
    | lines
    # Debug: Print selections to verify
    print $"Selections: ($selections)"
    # Check if selections is empty
    if ($selections | is-empty) {
      print "No selections made."
      cd $pwd
      return
    }
    # Use spread operator to pass list items as separate arguments
    nix flake update ...$selections
  } else {
    nh os switch -u $working_path
  }
  cd $pwd
  nh os switch $working_path
}

def nix-generations [
  --delete (-d) # Interactively delete selected generations
  --clean-older-than (-c): int # Delete generations older than X days
  --flake-path: string = "/home/jr/flake" # Path to your flake
]: nothing -> nothing {
  let working_path = $flake_path | path expand
  if not ($working_path | path exists) {
    echo "path does not exist: $working_path"
    exit 1
  }

  # List generations
  let generations = sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
    | lines
    | parse "{id}  {date} {time}  {current}"
    | select id date time current
    | update current { $in == "(current)" }
    | update id { $in | into int }
    | sort-by id

  if $delete {
    # Interactive deletion with fzf
    let selections = $generations
      | format "{id}  {date} {time} {current}"
      | fzf --multi --tmux center,40% --header "Select generations to delete (current generation is marked)"
      | lines
      | parse "{id}  {date} {time} {current}"
      | get id
      | into int

    if ($selections | is-empty) {
      print "No generations selected for deletion."
      return
    }

    print $"Selected generations for deletion: ($selections)"
    for id in $selections {
      if ($generations | where id == $id | get current.0) {
        print $"Skipping deletion of current generation: ($id)"
        continue
      }
      print $"Deleting generation: ($id)"
      sudo nix-env --delete-generations --profile /nix/var/nix/profiles/system $id
    }
  } else if $clean_older_than != null {
    # Delete generations older than specified days
    let threshold = (date now) - ($clean_older_than * 24 * 60 * 60 * 1000 * 1ns)
    let to_delete = $generations
      | where { ($in.date + " " + $in.time) | into datetime < $threshold } 
      | where current == false
      | get id

    if ($to_delete | is-empty) {
      print $"No generations older than ($clean_older_than) days found."
      return
    }

    print $"Deleting generations older than ($clean_older_than) days: ($to_delete)"
    for id in $to_delete {
      sudo nix-env --delete-generations --profile /nix/var/nix/profiles/system $id
    }
  } else {
    # Just list generations
    print "NixOS System Generations:"
    $generations | table
  }

  # Optional: Run garbage collection if deletions occurred
  if $delete or ($clean_older_than != null) {
    print "Running nix-collect-garbage to free disk space..."
    sudo nix-collect-garbage
  }
}
