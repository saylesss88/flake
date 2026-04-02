{
  lib,
  pkgs,
  homeManagerModules,
  ...
}:
{
  imports = [
    homeManagerModules
  ];

  home = {
    username = "jr";
    homeDirectory = lib.mkDefault "/home/jr";
  };

  custom = {
    magic.hm.enable = true;
    nh.enable = true;
    helix.enable = true;
    yazi.enable = true;
    fzf.enable = true;
    nushell.enable = true;
    mako.enable = true;
    mpv.enable = true;
    foot.enable = true;
    waybar.enable = true;
    git = {
      enable = true;
    };
    jj.enable = true;
    ghostty.enable = true;
    gpg.enable = true;
    # zed.enable = true;
  };

  programs.home-manager.enable = true;
  home.packages = [ pkgs.git ];
  xdg.userDirs.enable = true;

  xdg.userDirs.setSessionVariables = false;
  xdg.userDirs.createDirectories = true;
}
