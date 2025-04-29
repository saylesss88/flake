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

  outputs = inputs @ {
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
      flake = "/home/jr/my-nixos";
    };

    # Define pkgs with allowUnfree
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # Use nixpkgs.lib directly
    inherit (nixpkgs) lib;

    # Formatter configuration
    treefmtEval = treefmt-nix.lib.evalModule pkgs ./lib/treefmt.nix;
  in {
    # Formatter for nix fmt
    formatter.${system} = treefmtEval.config.build.wrapper;

    # Style check for CI
    checks.${system}.style = treefmtEval.config.build.check self;

    # Development shell
    devShells.${system}.default = import ./lib/dev-shell.nix {inherit inputs;};

    # REPL for debugging
    repl = import ./repl.nix {
      inherit pkgs lib;
      flake = self;
    };

    # User variables for modules
    inherit userVars;

    # Default package for tools
    packages.${system} = {
      default = pkgs.buildEnv {
        name = "default-tools";
        paths = with pkgs; [helix git ripgrep nh];
      };

      # Hugo site for Reddit posts
      reddit-posts = pkgs.stdenv.mkDerivation {
        name = "reddit-posts";
        src = ./reddit-posts;
        buildInputs = [pkgs.hugo];
        buildPhase = "${pkgs.hugo}/bin/hugo";
        installPhase = "mkdir -p $out; cp -r public/* $out";
      };
    };

    # Apps for rendering and deploying Hugo posts
    apps.${system} = {
      render-reddit-post = {
        type = "app";
        program = toString (pkgs.writeScript "render-reddit-post" ''
          #!/bin/sh
          cd ${../reddit-posts}
          ${pkgs.hugo}/bin/hugo
          echo "HTML output in reddit-posts/public/posts/"
        '');
      };
      preview-reddit-post = {
        type = "app";
        program = toString (pkgs.writeScript "preview-reddit-post" ''
          #!/bin/sh
          cd ${../reddit-posts}
          ${pkgs.hugo}/bin/hugo server
        '');
      };
      deploy-reddit-post = {
        type = "app";
        program = toString (pkgs.writeScript "deploy-reddit-post" ''
          #!/bin/sh
          cd ${./reddit-posts}
          ${pkgs.hugo}/bin/hugo
          git add .
          git commit -m "Deploy Hugo site"
          git push
          echo "Deployed to https://<your-username>.github.io/reddit-posts/"
        '');
      };
    };

    # NixOS configuration
    nixosConfigurations.${host} = lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs username system host userVars;
      };
      modules = [
        ./hosts/${host}/configuration.nix
        home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
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
