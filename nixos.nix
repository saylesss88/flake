{ inputs, self, lib, config, ... }:
{
  flake =
    let
      host = "magic";
      username = "jr";
      myLib = import ./lib/default.nix { inherit (inputs.nixpkgs) lib; };
      nixosModules = import ./nixos;
      homeManagerModules = import ./home;

      caches = {
        nix.settings = {
          builders-use-substitutes = true;
          substituters = [ "https://cache.nixos.org" ];
          trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
        };
      };
    in
    {
      # Notice we can't use 'pkgs' here directly because this is system-agnostic
      # But we can reference the system-specific pkgs via 'self.nixosConfigurations'
      nixosConfigurations.${host} = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            host
            username
            myLib
            self
            ;
        };

        modules = [
          nixosModules
          ./hosts/${host}/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          caches
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = ./hosts/${host}/home.nix;
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
