{...}: {
  wayland.windowManager.mango = {
    settings = ''
              # Key Bindings
      # key name refer to `xev` or `wev` command output,
      # mod keys name: super,ctrl,alt,shift,none

      # reload config(after rebuilding, reload_config)
      bind=SUPER,r,reload_config

      bind=SUPER,Return,spawn,ghostty
      bind=SUPER,T,spawn,foot
      bind=SUPER,O,spawn,firefox
      bind=SUPER,d,spawn,wofi --show drun
      bind=SUPER,Q,killclient
    '';
  };
}
