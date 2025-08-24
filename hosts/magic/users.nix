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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgNbyUMtnxTRySg8WsVIQyZ5dUJA8143fASDwumy5ZP (none)"
        ];
        # Change me!
        description = "saylesss88";
        hashedPasswordFile = config.sops.secrets.password_hash.path;
        # initialHashedPassword = "$y$j9T$XGZRNSIruxsAiF1KyaTAS/$6aICu4LJp0Fi./Qccdyf6giEPIJt0TIMCg/8Amh1Pr4";

        extraGroups = [
          "networkmanager"
          "wheel"
          "libvirtd"
          "scanner"
          "lp"
          "root"
          "jr"
          "sudo"
          "tss"
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
