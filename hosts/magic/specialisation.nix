{
  lib,
  pkgs,
  inputs,
  ...
}: {
  specialisation = {
    niri-test.configuration = {
      system.nixos.tags = ["niri"];

      # Add the Niri overlay for this specialisation
      nixpkgs.overlays = [inputs.niri.overlays.niri];

      # Enable Niri session
      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };

      # Optionally, add a test user and greetd for login
      users.users.niri = {
        isNormalUser = true;
        extraGroups = ["networkmanager" "video" "wheel"];
        initialPassword = "test"; # for testing only!
      };

      services.greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            command = lib.mkForce "${pkgs.niri}/bin/niri";
            user = lib.mkForce "niri";
          };
          default_session = initial_session;
        };
      };

      environment.etc."niri/config.kdl".text = ''
        binds {
          Mod+T { spawn "alacritty"; }
          Mod+D { spawn "fuzzel"; }
          Mod+Q { close-window; }
          Mod+Shift+Q { exit; }
        }
      '';
      environment.systemPackages = with pkgs; [
        alacritty
        waybar
        fuzzel
        mako
      ];

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        # Optionally:
        jack.enable = true;
      };

      hardware.alsa.enablePersistence = true;

      networking.networkmanager.enable = true;
    };
  };
}
