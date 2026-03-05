{
  inputs,
  self,
  lib,
  config,
  ...
}:
let
  # Global factory logic
  myLib = import "${self}/lib/default.nix" { inherit (inputs.nixpkgs) lib; };
  nixosModules = import "${self}/nixos";
  homeManagerModules = import "${self}/home";

  caches = {
    nix.settings = {
      builders-use-substitutes = true;
      substituters = [ "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
  };
in
{
  options.hosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          username = lib.mkOption {
            type = lib.types.str;
            default = "jr";
          };
          system = lib.mkOption {
            type = lib.types.str;
            default = "x86_64-linux";
          };
        };
      }
    );
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    host: cfg:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          self
          host
          myLib
          ;
        username = cfg.username;
      };

      modules = [
        nixosModules
        "${self}/hosts/${host}/configuration.nix"
        inputs.home-manager.nixosModules.home-manager
        caches
        {
          nixpkgs.hostPlatform = cfg.system;
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${cfg.username} = import "${self}/hosts/${host}/home.nix";
            extraSpecialArgs = {
              inherit
                inputs
                homeManagerModules
                myLib
                host
                ;
              username = cfg.username;
            };
          };
        }
      ];
    }
  ) config.hosts;
}
