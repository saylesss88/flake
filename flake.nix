{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
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
    # lanzaboote = {
    #   url = "github:nix-community/lanzaboote/v1.0.0";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    systems.url = "github:nix-systems/default-linux";
    wallpapers = {
      url = "github:saylesss88/wallpapers2";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      treefmt-nix,
      systems,
      ...
    }@inputs:
    let
      host = "magic";
      system = "x86_64-linux";
      username = "jr";
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      # inherit (pkgs.stdenv) system;
      lib = pkgs.lib // home-manager.lib;
      forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs (import systems) (
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = false;
          };
        }
      );
      getTreefmtEval = system: treefmt-nix.lib.evalModule pkgsFor.${system} ./lib/treefmt.nix;
      myLib = import ./lib/default.nix { inherit (nixpkgs) lib; };
      nixosModules = import ./nixos;
      homeManagerModules = import ./home;
      # overlays = import ./lib/overlay.nix {inherit (inputs) devour-flake;};
      caches = {
        nix.settings = {
          builders-use-substitutes = true;
          substituters = [ "https://cache.nixos.org" ];
          trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
        };
      };
    in
    {
      inherit lib;
      # Formatter for nix fmt
      formatter = forEachSystem (
        pkgs: (getTreefmtEval pkgs.stdenv.hostPlatform.system).config.build.wrapper
      );
      # Style check for CI
      # This creates checks.x86_64-linux.style etc.
      checks = forEachSystem (pkgs: {
        style = (getTreefmtEval pkgs.stdenv.hostPlatform.system).config.build.check self;
        # You can also expose specific custom checks like this:
        # no-todos = (getTreefmtEval pkgs.system).config.checks.no-todos.check self;
      });
      # Development shell
      devShells.${system}.default = import ./lib/dev-shell.nix { inherit inputs; };
      nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
        inherit system;
        pkgs = pkgsFor.${system};
        specialArgs = {
          inherit
            inputs
            host
            username
            myLib
            ;
        };

        modules = [
          nixosModules # add all modules from ./nixos
          ./hosts/${host}/configuration.nix
          home-manager.nixosModules.home-manager
          inputs.mango.nixosModules.mango
          caches

          # inputs.lanzaboote.nixosModules.lanzaboote

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Change `your-user`
            home-manager.users.jr = ./hosts/${host}/home.nix;
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
}
