{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.randpaper.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.rustup
    pkgs.zig
    pkgs.gcc
  ];
}
