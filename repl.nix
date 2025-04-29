{
  lib,
  flake,
  pkgs,
}: {
  inherit flake pkgs lib;
  configs = flake.nixosConfigurations;
  # inherit (flake.outputs) userVars;
}
# Accepts `lib`, `flake`, `pkgs` from `flake.nix` as arguments
# Attributes: flake: all flake outputs (flake.outputs, flake.inputs)
# run `nix repl .#repl` to load the REPL environment
# :l <nixpkgs>  # load additional Nixpkgs if needed
# :p flake.inputs.nixpkgs.rev # nixpkgs revision
# :p flake.inputs.home-manager.rev
# flake.outputs.packages.x86_64-linux.default # inspect default package
# pkgs.helix # access helix package
# lib.version # check lib version
# configs.magic.config.environment.systemPackages # list packages
# configs.magic.config.home-manager.users.jr.home.packages # home packages
# :p configs.magic.config.home-manager.users.jr.programs.git.userName
# Debugging
# :p builtins.typeOf configs.magic (should be `set`)
# :p builtins.attrNames configs.magic
# :p configs.magic.config # errors indicate issues
# :p configs.magic.config.environment # isolate the module or issue
# :p builtins.attrNames configs.magic.config.home-manager.users.jr # home attrs
# :p configs.magic.config.home-manager.users.jr.programs.git.enable # true/false
#  :p lib.filterAttrs (n: v: lib.hasPrefix "firefox" n) pkgs
# :p configs.magic.config.stylix # check theming
# :p configs.magic.config.home-manager.users.jr.stylix
# :p lib.mapAttrsToList (name: cfg: name) configs

