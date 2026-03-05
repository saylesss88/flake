{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
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
    treefmt-nix.url = "github:numtide/treefmt-nix";
    systems.url = "github:nix-systems/default-linux";
    wallpapers = {
      url = "github:saylesss88/wallpapers2";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # This tells flake-parts which systems to generate outputs for
      systems = import inputs.systems;

      imports = [
        # Optional: use external flake logic, e.g.
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        # Per-system outputs (pkgs, devShells, apps, etc.)
        # Recommended: move all package definitions here.
        # e.g. (assuming you have a nixpkgs input)
        # packages.foo = pkgs.callPackage ./foo/package.nix { };
        # packages.bar = pkgs.callPackage ./bar/package.nix {
        #   foo = config.packages.foo;
        # };
        {
          system,
          ...
        }:
        {

          treefmt = {
            projectRootFile = "flake.nix";
            imports = [ ./lib/treefmt.nix ];
          };

          # Your development shell
          devShells.default = import ./lib/dev-shell.nix { inherit inputs; };

          # Access pkgs with your specific config
          _module.args.pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = false;
          };
        };
      # end perSystem---------------------------------------------------------------------

      # Top-level flake outputs (NixOS configurations, etc.)
      flake =
        let
          host = "magic";
          username = "jr";
          myLib = import ./lib/default.nix { inherit (nixpkgs) lib; };
          nixosModules = import ./nixos;
          homeManagerModules = import ./home;

          caches = {
            nix.settings = {
              builders-use-substitutes = true;
              substituters = [ "https://cache.nixos.org" ];
              trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
            };
          };
        in
        {
          # Notice we can't use 'pkgs' here directly because this is system-agnostic
          # But we can reference the system-specific pkgs via 'self.nixosConfigurations'
          nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit
                inputs
                host
                username
                myLib
                self
                ;
            };

            modules = [
              nixosModules
              ./hosts/${host}/configuration.nix
              inputs.home-manager.nixosModules.home-manager
              caches
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = ./hosts/${host}/home.nix;
                home-manager.extraSpecialArgs = {
                  inherit
                    inputs
                    homeManagerModules
                    myLib
                    host
                    username
                    ;
                };
              }
            ];
          };
        };
    };
}
