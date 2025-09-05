## Debugging Hyprland and Home-Manager

Add the following to enable hyprland logs:

```nix
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        debug = {
          disable_logs = false;
        };
      };
```

```bash
cat $XDG_RUNTIME_DIR/hypr/$(ls -t $XDG_RUNTIME_DIR/hypr/ | head -n 1)/hyprland.log
```

**Previous Session**

```bash
cat $XDG_RUNTIME_DIR/hypr/$(ls -t $XDG_RUNTIME_DIR/hypr/ | head -n 2 | tail -n 1)/hyprland.log
```

## Home-Manager

```bash
journalctl -b
```

```bash
journalctl -b -u home-manager-jr
```

## Common Issues

The `oisd` blocklist isn't a flake and is updated often causing rebuilds to
fail. When this happens, running `nix flake update` syncs the NarHash and fixes
it.

I'm working on an issue where rebuilds succeed but `home-manager` fails on
rebuild. Adding a systemd wait was working but stopped.
