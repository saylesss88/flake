/**
  System Configuration Factory Module

  This module defines a custom schema for describing multiple NixOS hosts
  and automatically generates the corresponding `nixosConfigurations` flakes output.
*/
{
  inputs,
  self,
  lib,
  config,
  ...
}:
let
  # Internal Library & Module Imports

  # Initialize a custom library using the project's internal lib and nixpkgs
  myLib = import "${self}/lib/default.nix" { inherit (inputs.nixpkgs) lib; };

  # Import entry points for global NixOS and Home Manager shared modules
  nixosModules = import "${self}/nixos";
  homeManagerModules = import "${self}/home";

  # Shared Binary Cache Configuration
  caches = {
    nix.settings = {
      builders-use-substitutes = true;
      substituters = [ "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
  };
in
{
  /**
    SCHEMA DEFINITION
    Defines the 'hosts' option, allowing us to declare system metadata
    (e.g., username, architecture) in a structured attribute set.
  */
  options.hosts = lib.mkOption {
    description = "An attribute set of host definitions to be generated.";
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          username = lib.mkOption {
            type = lib.types.str;
            default = "jr";
            description = "Primary user account name for this host.";
          };
          system = lib.mkOption {
            type = lib.types.str;
            default = "x86_64-linux";
            description = "The target system architecture.";
          };
        };
      }
    );
  };

  # options.flake.nixosModules = lib.mkOption {
  #   type = lib.types.attrsOf lib.types.deferredModule;
  #   default = { };
  #   description = "NixOS modules exported by this flake.";
  # };

  options.flake.homeModules = lib.mkOption {
    type = lib.types.attrsOf lib.types.deferredModule;
    default = { };
    description = "Home Manager modules exported by this flake.";
  };
  /**
    CONFIGURATION GENERATION
    Iterates through the 'config.hosts' defined above and maps them to
    actual 'nixosSystem' instances for the Flake output.
  */
  config.flake.nixosConfigurations = lib.mapAttrs (
    host: cfg:
    inputs.nixpkgs.lib.nixosSystem {
      # Pass global context and metadata into the module system
      specialArgs = {
        inherit
          inputs
          self
          host
          myLib
          ;
        inherit (cfg) username;
      };

      modules = [
        # 1. Project-wide NixOS logic
        nixosModules

        # 2. Host-specific hardware/system configuration file
        "${self}/hosts/${host}/configuration.nix"

        # 3. Home Manager NixOS module (allows configuring HM within NixOS)
        inputs.home-manager.nixosModules.home-manager

        # 4. Standardized cache settings defined in 'let' block
        caches

        # 5. Inline configuration for system-specific and user-specific settings
        {
          nixpkgs.hostPlatform = cfg.system;
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            # Dynamically import the user's home configuration based on host/username
            users.${cfg.username} = {
              imports = [
                (import "${self}/hosts/${host}/home.nix")
              ]
              ++ (builtins.attrValues config.flake.homeModules);
            };

            # Pass unique context down to Home Manager modules
            extraSpecialArgs = {
              inherit
                inputs
                homeManagerModules
                myLib
                host
                ;
              inherit (cfg) username;
            };
          };
        }
      ];
      #++ (builtins.attrValues config.flake.nixosModules);
    }
  ) config.hosts;
}
