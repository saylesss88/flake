{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.custom.vm.guest-services;
in {
  options.custom.vm.guest-services = {
    enable = mkEnableOption "Enable Virtual Machine Guest Services";
  };

  config = mkIf cfg.enable {
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
    services.spice-webdavd.enable = true;
  };
}
