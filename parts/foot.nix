{
  flake.homeModules.foot =
    { config, lib, ... }:
    let
      cfg = config.custom.foot;
    in
    {

      options.custom.foot.enable = lib.mkEnableOption "Enable foot module";

      config = lib.mkIf cfg.enable {
        programs.foot.enable = true;
        programs.foot.server.enable = true;
        programs.foot.settings = {
          main = {
            term = "foot";
            font = "JetBrainsMono Nerd Font Mono:size=14";
            dpi-aware = "yes";
          };
          mouse = {
            hide-when-typing = "yes";
          };
        };
      };
    };
}
