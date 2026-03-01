{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../home
  ];
  # Change your-user
  home.username = "jr";
  # Change your-user
  home.homeDirectory = lib.mkDefault "/home/jr";
  home.stateVersion = "26.05";

  custom = {
    nh.enable = true;
    helix.enable = true;
    yazi.enable = true;
    git.enable = true;
    ghostty.enable = true;
    gpg.enable = true;
  };

  programs.home-manager.enable = true;
  home.packages = [
    pkgs.git
  ];
  # xdg.portal = { enable = true; extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; config.common.default = [ "gtk" ];
  # };
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;
}
