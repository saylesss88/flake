{
  myLib,
  lib,
  ...
}: {
  imports = myLib.scanPaths ./.;

  options.custom.ace.hm = {
    enable = lib.mkEnableOption "Enable Custom Home-Manager Modules Globally";
  };

  config = {
    custom.ace.hm.enable = lib.mkDefault false;
    home.stateVersion = "25.05";
  };
}
