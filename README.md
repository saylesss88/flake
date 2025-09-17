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

Check Boot Logs

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

### Scan for Infected Files

```bash
sudo clamscan -r .
```

**Intrusion Detection**:

```bash
sudo aide --update --config /var/lib/aide/aide.conf
sudo mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
```

```bash
sudo aide --check --config /var/lib/aide/aide.conf
```

### Need to Switch to an old generation?

Tap space as the machine reboots.
