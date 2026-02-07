{lib, ...}: {
  # Change your-user
  home.username = "jr";
  # Change your-user
  home.homeDirectory = lib.mkDefault "/home/jr";
  home.stateVersion = "25.05";

  imports = [
    ./home
  ];
  programs.home-manager.enable = true;

  custom = {
    hyprland.enable = true;
    ghostty.enable = true;
    helix.enable = true;
    kitty.enable = true;
    wlogout.enable = true;
    git.enable = true;
    yazi.enable = true;
    # fd.enable = true;
  };

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  #   config.common.default = [ "gtk" ];
  # };
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;
}
