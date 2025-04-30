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


def ns [
    term: string # Search target.
] {

    let info = (
        sysctl -n kernel.arch kernel.ostype
        | lines
        | {arch: ($in.0|str downcase), ostype: ($in.1|str downcase)}
    )

    nix search --json nixpkgs $term
        | from json
        | transpose package description
        | flatten
        | select package description version
        | update package {|row| $row.package | str replace $"legacyPackages.($info.arch)-($info.ostype)." ""}
}
