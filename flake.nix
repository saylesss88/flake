{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    systems.url = "github:nix-systems/default-linux";
    disko.url = "github:nix-community/disko";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    devour-flake.url = "github:srid/devour-flake";
    devour-flake.flake = false;
    dont-track-me.url = "github:dtomvan/dont-track-me.nix/main";
    hyprland.url = "github:hyprwm/Hyprland";
    helix.url = "github:helix-editor/helix";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    # 2. Override the flake-utils default to your version
    flake-utils.inputs.systems.follows = "systems";
    claude-desktop.url = "github:k3d3/claude-desktop-linux-flake";
    claude-desktop.inputs.nixpkgs.follows = "nixpkgs";
    claude-desktop.inputs.flake-utils.follows = "flake-utils"; # Corrected: should follow 'flake-utils'

    nvf.url = "github:notashelf/nvf";
    yazi.url = "github:sxyazi/yazi";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wallpapers = {
      url = "github:saylesss88/wallpapers";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    treefmt-nix,
    systems,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    host = "magic";
    # lib = nixpkgs.lib // home-manager.lib;
    lib = nixpkgs.lib;
    forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        }
    );
    getTreefmtEval = system: treefmt-nix.lib.evalModule pkgsFor.${system} ./lib/treefmt.nix;

    myLib = import ./lib/default.nix {inherit (nixpkgs) lib;};

    nixosModules = import ./nixos;

    homeManagerModules = import ./home;

    overlays = import ./lib/overlay.nix {devour-flake = inputs.devour-flake;};
  in {
    inherit lib;

    # Formatter for nix fmt
    formatter = forEachSystem (pkgs: (getTreefmtEval pkgs.system).config.build.wrapper);

    # Style check for CI
    # This creates checks.x86_64-linux.style etc.
    checks = forEachSystem (pkgs: {
      style = (getTreefmtEval pkgs.system).config.build.check self;
      # You can also expose specific custom checks like this:
      # no-todos = (getTreefmtEval pkgs.system).config.checks.no-todos.check self;
    });
    # formatter = forEachSystem (pkgs: pkgs.alejandra);
    # Development shell
    devShells.${system}.default = import ./lib/dev-shell.nix {
      inherit inputs;
    };

    nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      pkgs = pkgsFor.${system};
      specialArgs = {
        inherit inputs host myLib overlays;
      };
      modules = [
        ./hosts/${host}/configuration.nix
        home-manager.nixosModules.home-manager
        nixosModules # add all modules from ./nixos
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.jr = ./hosts/${host}/home.nix;
          home-manager.extraSpecialArgs = {
            inherit inputs host myLib homeManagerModules;
          };
        }
      ];
    };
  };
}
