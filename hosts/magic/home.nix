{
  pkgs,
  inputs,
  homeManagerModules,
  ...
}: {
  # Home Manager Settings
  home = {
    username = "jr";
    homeDirectory = "/home/jr";
    stateVersion = "25.05";
  };
  programs.home-manager.enable = true;
  # programs.nix-index.enable = true;

  # Import Program Configurations
  imports = [
    inputs.dont-track-me.homeManagerModules.default
    # inputs.nix-index-database.homeModules.nix-index
    # {programs.nix-index-database.comma.enable = true;}
    homeManagerModules
  ];

  # Custom home-manager modules
  custom = {
    magic.hm.enable = true;
    hyprland.enable = true;
    pgp.enable = true;
    wlogout.enable = true;
    helix.enable = true;
    ghostty.enable = true;
    brave.enable = true;
    # firefox.enable = true;
    librewolf.enable = true;
    # mullvad-browser.enable = true;
    qutebrowser.enable = true;
    kitty.enable = true;
    git = {
      enable = true;
      userName = "saylesss88";
      userEmail = "saylesss87@proton.me";
      # userName = "TSawyer87";
      # userEmail = "sawyerjr.25@gmail.com";
      # aliases = "";
      # ignores = "";
      # packages = "";
    };
    jj = {
      enable = true;
      userName = "saylesss88";
      userEmail = "saylesss87@proton.me";
    };
    nh = {
      enable = true;
      flake = "/home/jr/flake";
    };
    nvf.enable = true;
    bat.enable = true;
    yazi.enable = true;
    discord.enable = false;
  };

  dont-track-me = {
    enable = true;
    enableAll = true;
  };

  home.packages = with pkgs; [
    libnotify
    # ventoy
    gdb # Nix Debugger
  ];

  # Enable auto-mount
  services.udiskie.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # nixpkgs.config.allowUnfree = true;
}
