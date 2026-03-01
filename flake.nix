{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    mango = {
      url = "github:DreamMaoMao/mangowc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    randpaper.url = "github:saylesss88/randpaper";
    helix.url = "github:helix-editor/helix";
    awww.url = "git+https://codeberg.org/LGFae/awww";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    # lanzaboote = {
    #   url = "github:nix-community/lanzaboote/v1.0.0";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    wallpapers = {
      url = "github:saylesss88/wallpapers2";
      flake = false;
    };
    # impermanence.url = "github:nix-community/impermanence";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    host = "magic";
    system = "x86_64-linux";
    username = "jr";
  in {
    nixosConfigurations = {
      magic = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs host;
        };
        modules = [
          ./hosts/${host}/configuration.nix
          home-manager.nixosModules.home-manager
          inputs.mango.nixosModules.mango

          # inputs.lanzaboote.nixosModules.lanzaboote

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Change `your-user`
            home-manager.users.jr = ./hosts/${host}/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
          }
        ];
      };
    };
  };
}
