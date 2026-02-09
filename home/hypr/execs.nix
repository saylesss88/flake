{pkgs, ...}: {
  wayland.windowManager.hyprland = {
    settings = {
      exec-once = [
        "uwsm app -- swaybg"
        # "uwsm app -- swww-daemon"
        # "uwsm app -- hyprpaper"
        "uwsm app -- randpaper --time=15m /home/jr/Pictures/wallpapers2 --backend hyprland"
        # "/home/jr/projects/randpaper /home/jr/Pictures/Wallpapers --backend hyprland"
        # "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        # "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "uwsm app -- waybar"
        "uwsm app -- swaync"
        # "killall -q waybar;sleep .5 && uwsm app -- waybar"
        # "killall -q swaync;sleep .5 && uwsm app -- swaync"
        # "killall -q mako;sleep .5 && mako"
        # "sleep 1.5 && swww img /home/${username}/Pictures/Wallpapers/"
        # "killall -q swww;sleep .5 && swww init"
        "uwsm app -- udiskie -2"
        "uwsm app -- ydotoold"
        "uwsm app -- hypridle"
        "uwsm app -- nm-applet --indicator"
        "uwsm app -- lxqt-policykit-agent"
        # "polkit_gnome"
        "uwsm app -- pypr &"
        "uwsm app -- blueman-applet"
        # "wpaperd"
        "wl-paste --type text --watch cliphist store" # Stores only text data
        "wl-paste --type image --watch cliphist store" # Stores only image data
      ];
    };
  };
}
