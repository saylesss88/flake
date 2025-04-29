{inputs, ...}: let
  # Package declaration
  # ---------------------
  pkgs = import inputs.nixpkgs {
    inherit (inputs.lib) system;
    config.allowUnfree = true;
    overlays = [
      inputs.lib.overlays
      (_final: _prev: {
        userPkgs = import inputs.nixpkgs {
          config.allowUnfree = true;
        };
      })
    ];
  };
in {
  # Set pkgs for hydenix globally, any file that imports pkgs will use this
  nixpkgs.pkgs = pkgs;

  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    inputs.lib.nixOsModules
    ./modules/system

    # === GPU-specific configurations ===

    /*
    For drivers, we are leveraging nixos-hardware
    Most common drivers are below, but you can see more options here: https://github.com/NixOS/nixos-hardware
    */

    #! EDIT THIS SECTION
    # For NVIDIA setups
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia

    # For AMD setups
    inputs.nixos-hardware.nixosModules.common-gpu-amd

    # === CPU-specific configurations ===
    # For AMD CPUs
    inputs.nixos-hardware.nixosModules.common-cpu-amd

    # For Intel CPUs
    # inputs.hydenix.inputs.nixos-hardware.nixosModules.common-cpu-intel

    # === Other common modules ===
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
    };

    #! EDIT THIS USER (must match users defined below)
    users."jr" = {...}: {
      imports = [
        inputs.lib.homeModules
        ./modules/hm
      ];
    };
  };

  networking.hostName = "magic";

  #! EDIT THESE VALUES (must match users defined above)
  users.users.jr = {
    isNormalUser = true; # Regular user account
    initialPassword = "tbone123"; # Default password (CHANGE THIS after first login with passwd)
    extraGroups = [
      "wheel" # For sudo access
      "networkmanager" # For network management
      "video" # For display/graphics access
      # Add other groups as needed
    ];
    shell = pkgs.zsh; # Change if you prefer a different shell
  };

  system.stateVersion = "25.05";
}
