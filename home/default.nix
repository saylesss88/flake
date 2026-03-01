{...}: {
  imports = [
    # ./quickshell.nix
    ./packages.nix
    ./nh.nix
    ./gtk_theme.nix
    ./fd.nix
    ./fzf.nix
    ./jj.nix
    ./git.nix
    ./gpg-agent.nix
    ./yazi.nix
    ./helix
    ./terms
    ./shells
    ./mango
  ];
}
