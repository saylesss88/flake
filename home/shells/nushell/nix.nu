# list all installed packages
def nix-list-system []: nothing -> list<string> {
  ^nix-store -q --references /run/current-system/sw
  | lines
  | filter { not ($in | str ends-with 'man') }
  | each { $in | str replace -r '^[^-]*-' '' }
  | sort
}

# upgrade system packages
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
    | parse --regex '^\s*(?<id>\d+)\s+(?<date>\S+)?\s*(?<time>\S+)?\s*(?<current>\(current\))?\s*$'
    | where date != null and time != null # Filter out invalid entries
    | update current { |row| $row.current == "(current)" }
    | update id { |row| $row.id | into int }

  if ($generations | is-empty) {
    print "No valid generations found."
    return
  }

  if $delete {
    # Interactive deletion with fzf
    let selections = $generations
      | each { |row| $"($row.id)  ($row.date) ($row.time) ($row.current)" }
      | fzf --multi --tmux center,40% --header "Select generations to delete (current generation is marked)"
      | lines
      | parse --regex '^\s*(?<id>\d+)\s+(?<date>\S+)\s+(?<time>\S+)\s+(?<current>true|false)'
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
