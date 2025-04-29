{
  description = "NixOS and Home-Manager configuration with Hugo for Reddit posts";

  inputs = {
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    dont-track-me.url = "github:dtomvan/dont-track-me.nix/main";
    stylix.url = "github:danth/stylix";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi.url = "github:sxyazi/yazi";
    wezterm.url = "github:wezterm/wezterm?dir=nix";
    wallpapers = {
      url = "git+ssh://git@github.com/TSawyer87/wallpapers.git";
      flake = false;
    };
  };

  outputs = my-inputs @ {
    self,
    nixpkgs,
    home-manager,
    treefmt-nix,
    ...
  }: let
    system = "x86_64-linux";
    host = "magic";
    username = "jr";
    userVars = {
      gitEmail = "sawyerjr.25@gmail.com";
      gitUsername = "TSawyer87";
      editor = "hx";
      term = "ghostty";
      keys = "us";
      browser = "firefox";
      flake = builtins.getEnv "HOME" + "/my-nixos";
    };

    inputs =
      my-inputs
      // {
        pkgs = import inputs.nixpkgs {
          inherit system host username userVars;
        };
        lib = {
          overlays = import ./lib/overlay.nix;
          nixOsModules = import ./nixos;
          homeModules = import ./home;
          inherit system userVars;
        };
      };

    defaultConfig = import ./hosts/magic {
      inherit inputs;
    };
    # Define pkgs with allowUnfree
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # Use nixpkgs.lib directly
    inherit (nixpkgs) lib;

    # Formatter configuration
    treefmtEval = treefmt-nix.lib.evalModule pkgs ./lib/treefmt.nix;

    # REPL function for debugging
    repl = import ./repl.nix {
      inherit pkgs lib;
      flake = self;
    };
  in {
    # Formatter for nix fmt
    formatter.${system} = treefmtEval.config.build.wrapper;

    # Style check for CI
    checks.${system}.style = treefmtEval.config.build.check self;

    # Development shell
    devShells.${system}.default = import ./lib/dev-shell.nix {
      inherit inputs;
    };

    # Default package for tools
    packages.${system} = {
      default = pkgs.buildEnv {
        name = "default-tools";
        paths = with pkgs; [helix git ripgrep nh];
      };
      # build and deploy with `nix build .#nixos`
      nixos = defaultConfig.config.system.build.toplevel;
    };

    apps.${system}.deploy-nixos = {
      type = "app";
      program = toString (pkgs.writeScript "deploy-nixos" ''
        #!/bin/sh
        nix build .#nixos
        sudo ./result/bin/switch-to-configuration switch
      '');
      meta = {
        description = "Build and deploy NixOS configuration using nix build";
        license = lib.licenses.mit;
        maintainers = [
          {
            name = "TSawyer87";
            email = "sawyerjr.25@gmail.com";
          }
        ];
      };
    };

    # Custom outputs in legacyPackages
    legacyPackages.${system} = {
      inherit userVars repl;
    };

    # NixOS configuration
    nixosConfigurations.${host} = lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs my-inputs username system host userVars;
      };
      modules = [
        ./hosts/${host}/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = import ./hosts/${host}/home.nix;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {
            inherit inputs username system host userVars;
          };
        }
      ];
    };
  };
}
