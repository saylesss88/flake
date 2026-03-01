{ pkgs, ... }:

{
  # 1. Ensure wlr-randr is available to the system
  environment.systemPackages = [ pkgs.wlr-randr ];

  # 2. Create a "One-Shot" startup script
  systemd.user.services.setup-outputs = {
    description = "Force Wayland Monitor Configuration";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      # The actual command that fixed your layout + scaling
      ExecStart = ''
        ${pkgs.wlr-randr}/bin/wlr-randr \
          --output DP-1 --mode 3840x2160 --scale 2 --pos 0,0 \
          --output HDMI-A-1 --mode 1920x1080 --scale 1 --pos 1920,0
      '';
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
