{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.custom.packagesModule;
in {
  options.custom.packagesModule = {
    enable = lib.mkEnableOption "Enables the Packages Module";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        vim
        # system call monitoring
        teams-for-linux
        strace # system call monitoring
        ltrace # library call monitoring
        tcpdump # network sniffer
        lsof # list open files

        # ebpf related tools
        # https://github.com/bpftrace/bpftrace
        bpftrace # powerful tracing tool
        bpftop # monitor BPF programs
        bpfmon # BPF based visual packet rate monitor

        # system monitoring
        sysstat
        iotop
        iftop
        btop
        nmon
        sysbench
        # system tools
        psmisc # killall/pstree/prtstat/fuser/...
        lm_sensors # for `sensors` command
        ethtool
        pciutils # lspci
        usbutils # lsusb
        hdparm # for disk performance, command
        dmidecode # a tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard
        parted
        ;
    };

    # BCC - Tools for BPF-based Linux IO analysis, networking, monitoring, and more
    # https://github.com/iovisor/bcc
    programs.bcc.enable = true;
  };
}
