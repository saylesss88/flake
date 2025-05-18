{inputs, ...}:
inputs.nixpkgs.lib.nixosSystem {
  inherit (inputs.lib) system;
  specialArgs = {inherit inputs;};
  modules = [
    ./configuration.nix
    inputs.nix-index-database.hmModules.nix-index
  ];
}
