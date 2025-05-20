{
  pkgs,
  lib,
  inputs,
  host,
  system,
  colorscheme,
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
    # inputs.stylix.nixosModules.stylix
    inputs.home-manager.nixosModules.home-manager
  ];

  # Home-Manager Configuration needs to be here for home.packages to be available in the Configuration Package and VM i.e. `nix build .#nixos`
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit pkgs inputs host system colorscheme userVars;};
    users.jr = {...}: {
      imports = [
        inputs.lib.homeModules
        ./home.nix
      ];
    };
  };
  ############################################################################
  nix.settings.experimental-features = ["pipe-operators" "flakes" "nix-command"];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "codeium"
    ];

  nixpkgs.overlays = [inputs.lib.overlays inputs.codeium-flake.overlays.default];

  #  Enable/Disable Custom Modules
  custom = {
    # stylixModule.enable = true;
    cachixModule.enable = true;
    users.enable = true;
    drivers.amdgpu.enable = true;
    vm.guest-services.enable = true;
  };

  users = {
    mutableUsers = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [];
  # virtualisation.libvirtd.enable = true;
  # virtualisation.qemu.package = pkgs.qemu_kvm;
  # virtualisation.qemu.options = ["-enable-kvm"];
  # virtualisation.vmVariant = "kvm"; # Optimized for KVM
  # local.hardware-clock.enable = true;

  # During system activation, compare the closure size difference between the current and new system and display a formatted table if significant changes are detected.
  system.activationScripts.diff = ''
    if [[ -e /run/current-system ]]; then
      ${pkgs.nushell}/bin/nu -c "let diff_closure = (${pkgs.nix}/bin/nix store diff-closures /run/current-system '$systemConfig'); let table = (\$diff_closure | lines | where \$it =~ KiB | where \$it =~ → | parse -r '^(?<Package>\S+): (?<Old>[^,]+)(?:.*) → (?<New>[^,]+)(?:.*), (?<DiffBin>.*)$' | insert Diff { get DiffBin | ansi strip | into filesize } | sort-by -r Diff | reject DiffBin); if (\$table | get Diff | is-not-empty) { print \"\"; \$table | append [[Package Old New Diff]; [\"\" \"\" \"\" \"\"]] | append [[Package Old New Diff]; [\"\" \"\" \"Total:\" (\$table | get Diff | math sum) ]] | print; print \"\" }"
    fi
  '';

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
