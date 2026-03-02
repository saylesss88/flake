{
  lib,
  config,
  ...
}:
let
  cfg = config.custom.zram;
in
{
  options.custom.zram = {
    enable = lib.mkEnableOption "Enable utils module";
  };

  config = lib.mkIf cfg.enable {
    boot.tmp.useTmpfs = true;
    boot.tmp.tmpfsSize = "25%";
    zramSwap = {
      enable = true;
      # one of "lzo", "lz4", "zstd"
      algorithm = "zstd";

      priority = 5;

      memoryPercent = 50;
    };
  };
}
