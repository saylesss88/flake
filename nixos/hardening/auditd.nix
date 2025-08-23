{
  config,
  lib,
  ...
}:
with lib; {
  options.custom.security.auditd.enable = mkEnableOption "The Linux Audit Daemon";

  config = mkIf config.custom.security.auditd.enable {
    # Enable audit as early as possible during the boot process
    boot.kernelParams = ["audit=1"];
    security.auditd.enable = true;
    security.audit = {
      enable = true;
      rules = [
        # Program Executions
        # Log all program executions on 64-bit architecture
        "-a exit,always -F arch=b64 -S execve"
      ];
    };
  };
}
