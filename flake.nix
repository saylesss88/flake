{
  description = "NixOS and Home-Manager configuration";

  inputs = {
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    dont-track-me.url = "github:dtomvan/dont-track-me.nix/main";
    stylix.url = "github:danth/stylix";
    hyprland.url = "github:hyprwm/Hyprland";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    nvf.url = "github:notashelf/nvf";
    helix.url = "github:helix-editor/helix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
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
    treefmt-nix,
    ...
  }: let
    system = "x86_64-linux";
    host = "magic";
    userVars = {
      username = "jr";
      gitEmail = "sawyerjr.25@gmail.com";
      gitUsername = "TSawyer87";
      editor = "hx";
      term = "ghostty";
      keys = "us";
      browser = "firefox";
      flake = builtins.getEnv "HOME" + "/flake";
    };

    inputs =
      my-inputs
      // {
        pkgs = import inputs.nixpkgs {
          inherit system;
        };
        lib = {
          overlays = import ./lib/overlay.nix;
          nixOsModules = import ./nixos;
          homeModules = import ./home;
          inherit system;
        };
      };

    # defaultConfig = import ./hosts/magic {
    #   inherit inputs;
    # };

    # vmConfig = import ./lib/vms/nixos-vm.nix {
    #   nixosConfiguration = defaultConfig;
    #   inherit inputs;
    # };
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
    inherit (inputs) lib;
    # inherit (inputs) lib;
    # Formatter for nix fmt
    formatter.${system} = treefmtEval.config.build.wrapper;

    # Style check for CI
    checks.${system}.style = treefmtEval.config.build.check self;

    # Development shell
    devShells.${system}.default = import ./lib/dev-shell.nix {
      inherit inputs;
    };

    # templates = {
    #   default = {
    #     path = ./template;
    #     description = "flake template";
    #     welcomeText = ''
    #       👻
    #         1. edit `configuration.nix` with your preferences
    #           - visit https://github.com/TSawyer87/flake for
    #         2. run `sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix`
    #         3. `git init && git add .` (flakes have to be managed via git)
    #         4. run any of the packages in your new `flake.nix`
    #           - for rebuild, use `sudo nixos-rebuild switch --flake .`
    #         5. DON'T FORGET: change your password for all users with `passwd` from initialPassword set in `configuration.nix`
    #         6. NOTE: After rebuild, the first boot may take a while.
    #     '';
    #   };
    # };

    # Default package for tools
    packages.${system} = {
      default = pkgs.buildEnv {
        name = "default-tools";
        paths = with pkgs; [helix git ripgrep nh];
      };
      # build and deploy with `nix build .#nixos`
      # nixos = defaultConfig.config.system.build.toplevel;
      # Explicitly named Vm Configuration `nix build .#nixos-vm`
      # nixos-vm = vmConfig.config.system.build.vm;
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
            name = userVars.gitUsername;
            email = userVars.gitEmail;
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
        inherit inputs system host userVars;
      };
      modules = [
        ./hosts/${host}/configuration.nix
        (_: {
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
        })
      ];
    };
  };
}
