{
  pkgs,
  inputs,
  host,
  system,
  userVars,
  ...
}: {
  imports = [
    ./hardware.nix
    ./security.nix
    ./users.nix
    inputs.lib.nixOsModules
    # inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.stylix.nixosModules.stylix
    inputs.home-manager.nixosModules.home-manager
  ];

  # Home-Manager Configuration needs to be here for home.packages to be available in the Configuration Package and VM i.e. `nix build .#nixos`
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit pkgs inputs host system userVars;};
    users.jr = {...}: {
      imports = [
        inputs.lib.homeModules
        ./home.nix
      ];
    };
  };
  ############################################################################

  nixpkgs.overlays = [inputs.lib.overlays];

  # Enable or Disable Stylix
  stylixModule.enable = true;

  # Enable User module
  users.enable = true;
  users = {
    mutableUsers = true;
  };

  # Custom Cachix enable
  gytix.cachix.enable = true;

  # Custom amd module
  drivers.amdgpu.enable = true;

  vm.guest-services.enable = true;
  # virtualisation.libvirtd.enable = true;
  # virtualisation.qemu.package = pkgs.qemu_kvm;
  # virtualisation.qemu.options = ["-enable-kvm"];
  # virtualisation.vmVariant = "kvm"; # Optimized for KVM
  # local.hardware-clock.enable = true;

  # Enable Impermanence
  # isEphemeral = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # nixpkgs.config.permittedInsecurePackages = ["olm-3.2.16"];

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  # system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";

  # console.keyMap = userVars.keys;
  console.keyMap = "us";

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "magic";
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
