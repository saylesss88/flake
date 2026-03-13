{ pkgs, lib, ... }:
{
  users.users.jr = {
    isNormalUser = true;
    description = "jr";
    # uid = 1000;
    openssh = {
      authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDVsTKGkVTU3XQgCgVaebly/qQV5p0MtuCNezJNjaIX6 (none)"
      ];
    };
    extraGroups = lib.mkForce [
      # "libvirtd"
      # "kvm"
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ];
    group = "jr";
    ignoreShellProgramCheck = true;
    packages = with pkgs; [
      zoxide
      ripgrep
      btop
      tokei
      tealdeer
      eza
      #  thunderbird
    ];
    shell = pkgs.zsh;
    initialHashedPassword = "$y$j9T$AFAZpGibYMDWpL33h843d0$k1RwRXxHt2vOgXpnAM1zSaGUWKWsPaVi7pGc6QIGAW7";
  };
  users.mutableUsers = false;

  users.groups.jr = {
    # gid = lib.mkForce 1000;
  };
  # users.users.admin = {
  #   isNormalUser = true;
  #   description = "admin account";
  #   extraGroups = [ "wheel" ];
  #   group = "admin";
  #   initialHashedPassword = "$y$j9T$AFAZpGibYMDWpL33h843d0$k1RwRXxHt2vOgXpnAM1zSaGUWKWsPaVi7pGc6QIGAW7";
  # };

  # users.groups.admin = { };
}
