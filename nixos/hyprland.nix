{
  inputs,
  pkgs,
  lib,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  imports = [inputs.hyprland.nixosModules.default];

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
  # programs.uwsm.waylandCompositors.hyprland.binPath = lib.mkForce "/run/current-system/sw/bin/start-hyprland";

  programs = {
    hyprland = let
      hyprpkgs = inputs.hyprland.packages."${system}";
    in {
      enable = true;
      withUWSM = true;
      package = hyprpkgs.hyprland;
      portalPackage = hyprpkgs.xdg-desktop-portal-hyprland;
      # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };
}
