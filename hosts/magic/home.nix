{
  lib,
  pkgs,
  homeManagerModules,
  inputs,
  ...
}:
{
  imports = [
    homeManagerModules
    inputs.self.homeModules.helix
  ];

  home = {
    username = "jr";
    homeDirectory = lib.mkDefault "/home/jr";
    stateVersion = "26.05";
  };

  custom = {
    magic.hm.enable = true;
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
