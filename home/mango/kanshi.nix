{ pkgs, ... }: 

let
  monitors = {
    left = "DP-1";      # The 4K Sceptre
    right = "HDMI-A-1"; # The 1080p ViewSonic
  }; 
in {
  home.packages = with pkgs; [ kanshi ];

  services.kanshi = {
    enable = true;
    # "sway-session.target" won't work for mangowc. 
    # This generic target ensures it starts on any Wayland session.
    systemdTarget = "wayland-session.target"; 

    settings = [
      {
        profile.name = "home";
        profile.outputs = [
          {
            criteria = monitors.left;
            mode = "3840x2160";
            scale = 2.0;
            position = "0,0";
          }
          {
            criteria = monitors.right;
            mode = "1920x1080";
            scale = 1.0;
            # Logical width of left monitor is 3840 / 2 = 1920
            position = "1920,0"; 
          }
        ];
      }
    ];
  };
}
