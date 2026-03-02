{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    pkgs.brave
    pkgs.ffmpeg
  ];
}
