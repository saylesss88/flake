{ myLib, lib, ... }:
{
  imports = myLib.scanPaths ./.;

  options.custom.magic.hm = {
    enable = lib.mkEnableOption "Enable Custom Home-Manager Modules Globally";
  };

  config = {
    custom.magic.hm.enable = lib.mkDefault false;
    home.stateVersion = "26.05";
  };
}
