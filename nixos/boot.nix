{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.boot;
in {
  options.custom.boot = {
    enable = lib.mkEnableOption "Enable the Boot Module";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
      # LinuxZen Kernel
      # kernelPackages = pkgs.linuxPackages_zen;
      kernelPackages = pkgs.linuxPackages_xanmod_latest;
      # consoleLogLevel = 3;
      tmp = {
        useTmpfs = true;
        tmpfsSize = "50%";
      };
      # disable wifi powersave
      extraModprobeConfig = ''
        options iwlmvm  power_scheme=1
        options iwlwifi power_save=0
      '';
      # kernelParams = [
      #   # "security=selinux"
      #   # "enforcing=0"
      #   "quiet"
      #   "splash"
      #   "systemd.show_status=auto"
      #   "rd.udev.log_level=3"
      #   "plymouth.use-simpledrm"
      #   "resume_offset=269568"
      # ];
      blacklistedKernelModules = [
        # Obscure networking protocols
        "dccp"
        "sctp"
        "rds"
        "tipc"
        "n-hdlc"
        "ax25"
        "netrom"
        "x25"
        "rose"
        "decnet"
        "econet"
        "af_802154"
        "ipx"
        "appletalk"
        "psnap"
        "p8023"
        "p8022"
        "can"
        "atm"
        # Various rare filesystems
        "cramfs"
        "freevxfs"
        "jffs2"
        "hfs"
        "hfsplus"
        "udf"

        # "squashfs"
        "cifs"
        "nfs"
        "nfsv3"
        "nfsv4"
        "ksmbd"
        "gfs2"
        # vivid driver is only useful for testing purposes and has been the
        # cause of privilege escalation vulnerabilities
        "vivid"
      ];
      kernel.sysctl = {
        "vm.max_map_count" = 2147483642;
      };
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = lib.mkForce false;
          # enable = true;
          # configurationLimit = 15;
          # consoleMode = lib.mkDefault "max";
        };
      };
      plymouth = {
        enable = true;
        theme = "rings";
        font = "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = ["rings"];
          })
        ];
      };
      # Enable "Silent Boot"
      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
        "systemd.show_status=auto"
        "rd.udev.log_level=3"
        "resume_offset=269568"
        "boot.shell_on_fail"
        "quiet"
        "splash"
        "plymouth.use-simpledrm"
        "rd.systemd.show_status=false"
        # make it harder to influence slab cache layout
        "slab_nomerge"
        # enables zeroing of memory during allocation and free time
        # helps mitigate use-after-free vulnerabilaties
        "init_on_alloc=1"
        "init_on_free=1"
        # randomizes page allocator freelist, improving security by
        # making page allocations less predictable
        "page_alloc.shuffel=1"
        # enables Kernel Page Table Isolation, which mitigates Meltdown and
        # prevents some KASLR bypasses
        "pti=on"
        # randomizes the kernel stack offset on each syscall
        # making attacks that rely on a deterministic stack layout difficult
        "randomize_kstack_offset=on"
        # disables vsyscalls, they've been replaced with vDSO
        "vsyscall=none"
        # disables debugfs, which exposes sensitive info about the kernel
        "debugfs=off"
        # certain exploits cause an "oops", this makes the kernel panic if an "oops" occurs
        "oops=panic"
        # only alows kernel modules that have been signed with a valid key to be loaded
        # making it harder to load malicious kernel modules
        # can make VirtualBox or Nvidia drivers unusable
        "module.sig_enforce=1"
        # prevents user space code excalation
        "lockdown=confidentiality"
        # "rd.udev.log_level=3"
        # "udev.log_priority=3"
      ];
      # Hide the OS choice for bootloaders.
      # It's still possible to open the bootloader list by pressing any key
      # It will just not appear on screen unless a key is pressed
      loader.timeout = 0;
    };
    environment.systemPackages = with pkgs; [tuigreet];
    # systemd.package = pkgs.systemd.override { withSelinux = true; };
  };
}
