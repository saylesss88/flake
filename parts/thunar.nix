{
  flake.nixosModules.thunar =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      cfg = config.custom.thunar;
    in
    {
      options.custom.thunar.enable = lib.mkEnableOption "Enable thunar module";

      config = lib.mkIf cfg.enable {
        programs = {
          thunar = {
            enable = true;
            plugins = with pkgs; [
              thunar-archive-plugin
              thunar-volman
            ];
          };
        };
      };
    };
}
