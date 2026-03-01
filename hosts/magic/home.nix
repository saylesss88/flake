{
  lib,
  pkgs,
  homeManagerModules,
  ...
}:
{
  imports = [ homeManagerModules ];

  home = {
    username = "jr";
    homeDirectory = lib.mkDefault "/home/jr";
    stateVersion = "26.05";
  };

  custom = {
    nh.enable = true;
    helix.enable = true;
    yazi.enable = true;
    git = {
      enable = true;
    };
    ghostty.enable = true;
    gpg.enable = true;
  };

  programs.home-manager.enable = true;
  home.packages = [ pkgs.git ];
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;
}
