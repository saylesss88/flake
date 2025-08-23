{pkgs, ...}: {
  # Enable AppArmor support in D-Bus
  services.dbus.apparmor = "enabled";
  security = {
    apparmor = {
      enable = true;
      enableCache = true;
      killUnconfinedConfinables = true;

      # Only need packages that provide real, used profiles and tools
      packages = with pkgs; [apparmor-utils apparmor-profiles];

      includes = {
        "abstractions/base" = ''
          /nix/store/*/bin/** mr,
          /nix/store/*/lib/** mr,
          /nix/store/** r,
          ${pkgs.coreutils}/bin/* rix,
          ${pkgs.coreutils-full}/bin/* rix,
        '';
        # "local/firefox" = ''
        #   @{HOME}/.mozilla/firefox/** mr,
        # '';

        # "local/xdg-mime" = ''
        #   #        include <abstractions/app/bus>
        #           /bin/grep rix,
        #           /bin/gawk rix,
        #   #        /bin/dbus-send Cx -> bus,
        #           /dev/tty* rw,
        # '';

        # "local/pkexec" = ''
        #   capability sys_ptrace,
        # '';

        # "local/xdg-open" = ''
        #   /** r,
        # '';

        # "local/child-open" = ''
        #   # include <abstractions/app/bus>
        #   @{bin}/grep ix,
        #   /@{PROC}/version r,
        #   # @{bin}/gdbus Cx -> bus,
        #   @{bin}/gdbus Ux,
        # '';

        # "local/sudo" = ''
        #   /run/wrappers/wrappers.*/unix_chkpwd rPx -> unix-chkpwd,
        # '';
      };

      # Example starter policies
      policies = {
        sshd = {
          profile = ''
            #include <tunables/global>
            /run/current-system/sw/bin/sshd {
              /nix/store/** rix,
              # ...
            }
          '';
          # Optionally, you may be able to add (if supported):
          # enforce = true;
          # enable = true;
        };

        #     firefox = {
        #       profile = ''
        #         #include <tunables/global>
        #         #include <abstractions/base>
        #         /run/current-system/sw/bin/firefox {
        #           # Allow mapping and reading Nix store binaries and libs
        #           /nix/store/** mr,
        #           # Standard Firefox profile folder access (adjust `@{HOME}` as needed)
        #           owner @{HOME}/.mozilla/firefox/** rw,
        #           owner @{HOME}/.cache/mozilla/firefox/** rw,
        #           # Temporary files, system access as needed
        #           /tmp/** rw,
        #           /dev/shm/** rw,
        #           # Permit opening device files for sound/video
        #           /dev/snd/* rw,
        #           /dev/dri/* rw,
        #           /dev/video* rw,
        #           # Environment variables (for sandboxed child processes)
        #           /proc/*/fd/ r,
        #           # Network access (allows outbound browsing)
        #           network inet stream,
        #           network inet6 stream,
        #         }
        #       '';
        #       # enforce = true;
        #       # enable = true;
        #     };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    apparmor-utils
    apparmor-parser
    apparmor-profiles
    # Optional: community/contrib profiles you intend to use
    roddhjav-apparmor-rules
  ];

  # If you want PAM integration (useful)
  security.pam = {
    services.login.enableAppArmor = true;
    services.sshd.enableAppArmor = true;
    services.sudo-rs.enableAppArmor = true;
    services.su.enableAppArmor = true;
    services.u2f.enableAppArmor = true;
  };
}
