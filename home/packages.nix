{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    inputs.px2ansi-rs.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.brave
    pkgs.ffmpeg
  ];
}
