{
  myLib,
  lib,
  config,
  ...
}: {
  imports = myLib.scanPaths ./.;

  options.custom.ace = {
    enable = lib.mkEnableOption "Enable magic modules globally";

    hostname = lib.mkOption {
      type = lib.types.str;
      description = "Hostname";
      example = "ace";
    };

    timezone = lib.mkOption {
      type = lib.types.str;
      description = "Timezone";
      example = "America/New_York";
    };

    locale = lib.mkOption {
      type = lib.types.str;
      description = "Locale";
      example = "en_US.UTF-8";
    };
  };

  config = {
    custom.ace.enable = lib.mkDefault false;

    # Assertions to check if required variables are set when magic is enabled
    assertions = lib.mkIf config.custom.ace.enable [
      {
        assertion = config.custom.ace.hostname != "";
        message = "ace.hostname must be set";
      }
      {
        assertion = config.custom.ace.timezone != "";
        message = "ace.timezone must be set";
      }
      {
        assertion = config.custom.ace.locale != "";
        message = "ace.locale must be set";
      }
    ];

    # Configuration for variables (only applied when magic is enabled)
    time.timeZone = lib.mkIf config.custom.ace.enable config.custom.ace.timezone;
    i18n.defaultLocale = lib.mkIf config.custom.ace.enable config.custom.ace.locale;
    networking.hostName = lib.mkIf config.custom.ace.enable config.custom.ace.hostname;

    system.stateVersion = "25.05";
  };
}
