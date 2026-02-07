{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    # lanzaboote = {
    #   url = "github:nix-community/lanzaboote/v1.0.0";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # impermanence.url = "github:nix-community/impermanence";
    wallpapers = {
      url = "github:saylesss88/wallpapers2";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    {
      nixosConfigurations = {
        magic = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            # inputs.lanzaboote.nixosModules.lanzaboote

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # Change `your-user`
              home-manager.users.jr = ./home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };

            }
          ];
        };
      };
    };
}
