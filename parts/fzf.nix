{
  flake.homeModules.fzf =
    { lib, config, ... }:
    let
      cfg = config.custom.fzf;
    in
    {
      options.custom.fzf.enable = lib.mkEnableOption "Enable fzf module";

      config = lib.mkIf cfg.enable {
        programs.fzf = {
          enable = true;
          # colors = lib.mkForce { };

          defaultOptions = [
            "--height 40%"
            "--reverse"
            "--border"
            "--color=16"
          ];

          defaultCommand = "rg --files --hidden --glob=!.git/";
        };
      };
    };
}
