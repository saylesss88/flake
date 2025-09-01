{
  config,
  lib,
  ...
}: let
  cfg = config.custom.virtualbox;
in {
  options.custom.virtualbox = {
    enable = lib.mkEnableOption "Enable VirtualBox";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.virtualbox.host = {
      enable = false;
      # enableExtensionPack = true;
    };

    # user.extraGroups = ["vboxusers"];

    boot.kernelModules =
      if config.hardware.cpu.amd.updateMicrocode
      then ["kvm-amd"]
      else ["kvm-intel"];
  };
}
