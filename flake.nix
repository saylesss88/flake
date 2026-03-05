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
        ./nixos.nix
      ];

      hosts = {
        magic = {
          username = "jr";
          system = "x86_64-linux";
        };
        # Adding a second machine is now 4 lines of code:
        # secondary = { username = "jr"; system = "aarch64-linux"; };
      };

      perSystem =
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

    };
}
