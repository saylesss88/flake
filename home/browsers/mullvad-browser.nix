{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.custom.mullvad-browser;
in {
  options = {
    custom.mullvad-browser = {
      enable = lib.mkEnableOption {
        description = "Enable Mullvad Browser";
        default = false;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.mullvad-browser
    ];
  };
}
