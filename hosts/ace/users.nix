{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    # Enabled with custom.users.enable = true; in `configuration.nix`
    custom.users.enable = lib.mkEnableOption "Enables users module";
  };

  config = lib.mkIf config.custom.users.enable {
    users.users = {
      jr = {
        homeMode = "755";
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJuqQoegFi1BMsk0XybuIHqDmvHKzJAVaVC+BsONqAn (none)"
        ];
        # Change me!
        description = "saylesss88";
        hashedPasswordFile = config.sops.secrets.password_hash.path;
        extraGroups = [
          "networkmanager"
          "wheel"
          "libvirtd"
          "kvm"
          "scanner"
          "lp"
          "root"
          "jr"
          "sudo"
          "tss"
          "vboxusers"
        ];
        shell = pkgs.nushell;
        # shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
        packages = [
          pkgs.tealdeer
          pkgs.zoxide
          pkgs.mcfly
          pkgs.tokei
          pkgs.stow
        ];
      };
      # "newuser" = {
      #   homeMode = "755";
      #   isNormalUser = true;
      #   description = "New user account";
      #   extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
      #   shell = pkgs.bash;
      #   ignoreShellProgramCheck = true;
      #   packages = with pkgs; [];
      # };
    };
  };
}
