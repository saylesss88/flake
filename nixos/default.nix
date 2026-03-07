{
  myLib,
  lib,
  config,
  ...
}:
{
  imports = myLib.scanPaths ./.;

  options.custom.magic = {
    enable = lib.mkEnableOption "Enable magic modules globally";

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Hostname";
    };

    timezone = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Timezone";
    };

    locale = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Locale";
    };
  };

  config = lib.mkIf config.custom.magic.enable {
    # Only apply these IF they are actually set (not empty strings)
    time.timeZone = lib.mkIf (config.custom.magic.timezone != "") config.custom.magic.timezone;
    i18n.defaultLocale = lib.mkIf (config.custom.magic.locale != "") config.custom.magic.locale;
    networking.hostName = lib.mkIf (config.custom.magic.hostname != "") config.custom.magic.hostname;

    system.stateVersion = "25.11";
  };
}
