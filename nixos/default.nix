{...}: {
  imports = [
    ./drivers
    ./boot.nix
    ./utils.nix
    ./networking.nix
    ./services.nix
    ./hardware.nix
    ./nix.nix
    ./xdg.nix
    ./zram.nix
    ./stylix.nix
    ./fonts.nix
    ./i18n.nix
    ./environmentVariables.nix
    ./virtualization.nix
    ./vm-guest-services.nix
    ./greetd.nix
    ./cachix.nix
    ./pipewire.nix
    ./packages.nix
    ./programs.nix
    ./keyd.nix
    ./thunar.nix
    ./lsp.nix
  ];
}
# {
#   drivers = import ./drivers.nix;
#   boot = import ./boot.nix;
#   utils = import ./utils.nix;
# }

