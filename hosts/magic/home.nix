{
  pkgs,
  inputs,
  ...
}: {
  # Home Manager Settings
  home = {
    username = "jr";
    homeDirectory = "/home/jr";
    stateVersion = "25.05";
  };
  programs.home-manager.enable = true;

  # Import Program Configurations
  imports = [
    inputs.dont-track-me.homeManagerModules.default
  ];

  # Custom home-manager modules
  custom = {
    hyprland.enable = true;
    wlogout.enable = true;
    gitModule = {
      enable = true;
      userName = "saylesss88";
      userEmail = "saylesss87@proton.me";
      # aliases = "";
      # ignores = "";
      # packages = "";
    };
    jjModule = {
      enable = true;
    };
    nhModule = {
      enable = true;
      flake = "/home/jr/flake";
    };
    nvfModule.enable = false;
    batModule.enable = true;
    yaziModule.enable = true;
    discord.enable = true;
    webcord.enable = true;
    vesktop.enable = true;
  };

  dont-track-me = {
    enable = true;
    enableAll = true;
  };

  home.packages = with pkgs; [
    libnotify
    ventoy
    gdb # Nix Debugger
  ];

  # Enable auto-mount
  services.udiskie.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Styling Options
  stylix = {
    targets = {
      waybar.enable = false;
      rofi.enable = false;
      wofi.enable = false;
      mako.enable = false;
      hyprland.enable = false;
      hyprlock.enable = false;
      helix.enable = false;
      # ghostty.enable = false
      # zed.enable = false
      # nvf.enable = false
    };
  };
}
