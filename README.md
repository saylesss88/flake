## Debugging Hyprland and Home-Manager

```bash
cat $XDG_RUNTIME_DIR/hypr/$(ls -t $XDG_RUNTIME_DIR/hypr/ | head -n 1)/hyprland.log
```

**Previous Session**

```bash
cat $XDG_RUNTIME_DIR/hypr/$(ls -t $XDG_RUNTIME_DIR/hypr/ | head -n 2 | tail -n 1)/hyprland.log
```

## Home-Manager

```bash
systemctl --user status home-manager-$USER.service
```
