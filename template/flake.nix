{
  description = "template for hydenix";

  inputs = {
    # User's nixpkgs - for user packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs: let
    HOSTNAME = "magic";

    myConfig = inputs.nixpkgs.lib.nixosSystem {
      inherit (inputs.lib) system;
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./configuration.nix
      ];
    };
  in {
    nixosConfigurations.nixos = myConfig;
    nixosConfigurations.${HOSTNAME} = myConfig;
  };
}
