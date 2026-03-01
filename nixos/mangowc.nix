{ pkgs, inputs, ... }:
{
  imports = [
    inputs.mango.nixosModules.mango
  ];
  programs.mango.enable = true;

  environment.systemPackages = with pkgs; [
    foot
    wofi
    wmenu
    wl-clipboard
    grim
    slurp
    swaybg
    firefox
  ];

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
}
