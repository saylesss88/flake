{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # lix-module = {
    #   url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    oisd = {
      url = "https://big.oisd.nl/domainswild";
      flake = false;
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    systems.url = "github:nix-systems/default-linux";
    disko.url = "github:nix-community/disko";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-index-database.url = "github:nix-community/nix-index-database";
    sddm-catppuccin.url = "github:khaneliman/catppuccin-sddm-corners";
    sddm-catppuccin.inputs.nixpkgs.follows = "nixpkgs";
    dont-track-me.url = "github:dtomvan/dont-track-me.nix/main";
    hyprland.url = "github:hyprwm/Hyprland";
    helix.url = "github:helix-editor/helix";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nvf.url = "github:notashelf/nvf";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # yazi.url = "github:sxyazi/yazi";
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
      url = "github:saylesss88/wallpapers2";
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
    host = "ace";
    username = "jr";
    # lib = nixpkgs.lib // home-manager.lib;
    inherit (nixpkgs) lib;
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

    # overlays = import ./lib/overlay.nix {inherit (inputs) devour-flake;};

    caches = {
      nix.settings = {
        builders-use-substitutes = true;
        substituters = [
          "https://cache.nixos.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
      };
    };
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

    # Development shell
    devShells.${system}.default = import ./lib/dev-shell.nix {
      inherit inputs;
    };

    nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      pkgs = pkgsFor.${system};
      specialArgs = {
        inherit inputs host username myLib;
      };
      modules = [
        ./hosts/${host}/configuration.nix
        home-manager.nixosModules.home-manager
        # inputs.lix-module.nixosModules.default
        nixosModules # add all modules from ./nixos
        caches
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.users.jr = ./hosts/${host}/home.nix;
          home-manager.extraSpecialArgs = {
            inherit inputs host username myLib homeManagerModules;
          };
        }
      ];
    };
  };
}
