{
  description = "NixOS and Home-Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
     disko.url = "github:nix-community/disko";
     disko.inputs.nixpkgs.follows = "nixpkgs"; # Ensure disko uses the same nixpkgs version
    # # Add impermanence flake input (optional, but good for managing state)
     impermanence.url = "github:nix-community/impermanence";
    # flake-schemas.url = "github:DeterminateSystems/flake-schemas";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # nixCats.url = "github:BirdeeHub/nixCats-nvim";
    # nixCats.inputs.nixpkgs.follows = "nixpkgs";
    codeium-flake.url = "path:./home/nixVim/codeiumFlake";
    dont-track-me.url = "github:dtomvan/dont-track-me.nix/main";
    hyprland.url = "github:hyprwm/Hyprland";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    nvf.url = "github:notashelf/nvf";
    # nixvim.url = "github:nix-community/nixvim";
    helix.url = "github:helix-editor/helix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    yazi.url = "github:sxyazi/yazi";
    wezterm.url = "github:wezterm/wezterm?dir=nix";
    wezterm.inputs.nixpkgs.follows = "nixpkgs";
    wallpapers = {
      url = "github:saylesss88/wallpapers";
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
    colorscheme = "tokyonight_night";
    userVars = {
      username = "jr";
      gitEmail = "saylesss87@proton.me";
      gitUsername = "saylesss88";
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
  in {
    # inherit (inputs) lib;

    # inherit (inputs.flake-schemas) schemas;
    # inherit (inputs) lib;
    # Formatter for nix fmt
    formatter.${system} = treefmtEval.config.build.wrapper;

    # Style check for CI
    checks.${system}.style = treefmtEval.config.build.check self;

    # Development shell
    devShells.${system}.default = import ./lib/dev-shell.nix {
      inherit inputs;
    };

    templates = {
      default = {
        path = ./template;
        description = "flake template";
        welcomeText = ''
          👻
            1. edit `configuration.nix` with your preferences
              - visit https://github.com/TSawyer87/flake for
            2. run `sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix`
            3. `git init && git add .` (flakes have to be managed via git)
            4. run any of the packages in your new `flake.nix`
              - for rebuild, use `sudo nixos-rebuild switch --flake .`
            5. DON'T FORGET: change your password for all users with `passwd` from initialPassword set in `configuration.nix`
            6. NOTE: After rebuild, the first boot may take a while.
        '';
      };
    };

    # defaultPackage.x86_64-linux =
    #   # Notice the reference to nixpkgs here.
    #   with import nixpkgs {system = "x86_64-linux";};
    #     stdenv.mkDerivation {
    #       name = "hello";
    #       src = self;
    #       buildPhase = "gcc -o hello ./hello.c";
    #       installPhase = "mkdir -p $out/bin; install -t $out/bin hello";
    #     };
    # # Default package for tools
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

    # NixOS configuration
    nixosConfigurations.${host} = lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs system host userVars colorscheme;
      };
      modules = [
        ./hosts/${host}/configuration.nix
        (_: {
          # provides rev from `nixos-version --json`
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
        })
      ];
    };
  };
}
