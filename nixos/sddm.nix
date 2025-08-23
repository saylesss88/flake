{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.custom.sddm;
in {
  options.custom.sddm = {
    enable = mkEnableOption "Enable SDDM display manager for Hyprland";
  };

  config = mkIf cfg.enable {
    services.displayManager.sddm = {
      package = lib.mkForce pkgs.kdePackages.sddm;
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-sddm-corners";
      settings = {
        General = {
          DisplayServer = "wayland";
          Numlock = "on";
          RememberLastUser = true;
          RememberLastSession = true;
        };
        Users = {
          MinimumUid = 1000;
          MaximumUid = 60000;
          RememberLastUser = true;
        };
        Wayland.SessionDir = "${
          inputs.hyprland.packages."${pkgs.system}".hyprland
        }/share/wayland-sessions";
      };
    };
    environment.systemPackages = [
      (pkgs.catppuccin-sddm.override {
        flavor = "frappe";
        font = "Iosevka Nerd Font";
        fontSize = "15";
        background = "${inputs.wallpapers}/space.jpg";
        loginBackground = true;
      })
    ];

    security.pam.services.sddm.enableGnomeKeyring = true;
    security.pam.services.sddm-greeter.enableGnomeKeyring = true;
  };
}
