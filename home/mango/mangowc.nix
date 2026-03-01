{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.mango.hmModules.mango
    ./keybinds.nix
  ];
  home.packages = [
    pkgs.nixfmt
    pkgs.taplo
    pkgs.wpaperd
    pkgs.wl-clipboard
    pkgs.swaybg
    pkgs.networkmanagerapplet
  ];
  wayland.windowManager.mango = {
    enable = true;
    settings = ''
      #=========================================================#
      # Execs
      #=========================================================#
      exec-once=~/.config/mango/autostart.sh
      #=========================================================#
      # Monitor Layout DP-1 left, HDMI-A-1 right
      #=========================================================#
      # Logical layout: 4K (Scale 2) starts at 0,0. 1080p starts at 1920,0.
      # monitorrule=name:DP-1,res:3840x2160,pos:0,0,scale:2,enabled:1
      # monitorrule=name:HDMI-A-1,res:1920x1080,pos:1920,0,scale:1,enabled:1
      monitorrule=name:DP-1,width:3840,height:2160,refresh:60,x:0,y:0,scale:2
      monitorrule=name:HDMI-A-1,width:1920,height:1080,refresh:60,x:1920,y:0,scale:1
      #=========================================================#
      # Animations
      #=========================================================#
      # --- mangowc flags (1 = enabled, 0 = disabled) ---
      animations=1
      layer_animations=1
      animation_type_open=slide
      animation_type_close=slide
      animation_fade_in=1
      animation_fade_out=1
      tag_animation_direction=1
      zoom_initial_ratio=0.3
      zoom_end_ratio=0.8
      fadein_begin_opacity=0.5
      fadeout_begin_opacity=0.8
      animation_duration_move=500
      animation_duration_open=400
      animation_duration_tag=350
      animation_duration_close=800
      animation_duration_focus=0
      animation_curve_open=0.46,1.0,0.29,1
      animation_curve_move=0.46,1.0,0.29,1
      animation_curve_tag=0.46,1.0,0.29,1
      animation_curve_close=0.08,0.92,0,1
      animation_curve_focus=0.46,1.0,0.29,1
      animation_curve_opafadeout=0.5,0.5,0.5,0.5
      animation_curve_opafadein=0.46,1.0,0.29,1
      #=========================================================#
      # Blur (NOTE: Blur has a high impact on performance)
      #=========================================================#
      blur=0
      blur_layer=0
      blur_optimized=1
      blur_params_num_passes = 2
      blur_params_radius = 5
      blur_params_noise = 0.02
      blur_params_brightness = 0.9
      blur_params_contrast = 0.9
      blur_params_saturation = 1.2

      #=========================================================#
      # Shadows (Distinguish floating windows from bg)
      #=========================================================#
      shadows = 1
      layer_shadows = 1
      shadow_only_floating = 1
      shadows_size = 10
      shadows_blur = 15
      shadows_position_x = 0
      shadows_position_y = 0
      shadowscolor= 0x000000ff

      border_radius=6
      no_radius_when_single=0
      focused_opacity=1.0
      unfocused_opacity=0.9
      #=========================================================#
      # Scroller Layout Settings
      #=========================================================#
      # Scroller Layout Setting
      scroller_structs=20
      scroller_default_proportion=0.8
      scroller_focus_center=0
      scroller_prefer_center=0
      edge_scroller_pointer_focus=1
      scroller_default_proportion_single=1.0
      scroller_proportion_preset=0.5,0.8,1.0

      #=========================================================#
      # Master-Stack Layout Setting
      #=========================================================#
      # new_is_master=1
      # default_mfact=0.55
      # default_nmaster=1
      smartgaps=0

      #=========================================================#
      # Overview Setting
      #=========================================================#
      hotarea_size=1
      enable_hotarea=1
      ov_tab_mode=0
      overviewgappi=5
      overviewgappo=30

      #=========================================================#
      # Misc
      #=========================================================#
      no_border_when_single=0
      axis_bind_apply_timeout=100
      focus_on_activate=1
      idleinhibit_ignore_visible=0
      sloppyfocus=1
      warpcursor=1
      focus_cross_monitor=0
      focus_cross_tag=0
      enable_floating_snap=0
      snap_distance=30
      cursor_size=24
      drag_tile_to_tile=1

      #=========================================================#
      # keyboard
      #=========================================================#
      repeat_rate=50
      repeat_delay=300
      numlockon=0
      xkb_rules_layout=us
      # map escape to Caps lock
      xkb_rules_options=caps:escape


      #=========================================================#
      # Trackpad
      #=========================================================#
      # need relogin to make it apply
      disable_trackpad=0
      tap_to_click=1
      tap_and_drag=1
      drag_lock=1
      trackpad_natural_scrolling=1
      disable_while_typing=1
      left_handed=0
      middle_button_emulation=0
      swipe_min_threshold=1

      #=========================================================#
      # mouse
      #=========================================================#
      # need relogin to make it apply
      mouse_natural_scrolling=0

      #=========================================================#
      # Appearance
      #=========================================================#
      gappih=5
      gappiv=5
      gappoh=10
      gappov=10
      scratchpad_width_ratio=0.8
      scratchpad_height_ratio=0.9
      borderpx=1
      # rootcolor=0x201b14ff
      # bordercolor=0x444444ff
      # focuscolor=0xc9b890ff
      # maximizescreencolor=0x89aa61ff
      # urgentcolor=0xad401fff
      # scratchpadcolor=0x516c93ff
      # globalcolor=0xb153a7ff
      # overlaycolor=0x14a57cff

      #=========================================================#
      # Tokyo Night - Night (OLED / ultra dark)
      #=========================================================#

      # Compositor background
      rootcolor=0x1a1b26ff

      # Inactive window borders
      bordercolor=0x292e42ff

      # Focused window glow
      # focuscolor=0x7aa2f7ff
      focuscolor=0x5f7fd8ff

      # Maximized window indicator
      maximizescreencolor=0x9ece6aff

      # Urgent window
      urgentcolor=0xf7768eff

      # Scratchpad windows
      scratchpadcolor=0x7dcfffff

      # Global accents (UI highlights)
      globalcolor=0xbb9af7ff

      # Overlays, menus, effects
      overlaycolor=0x9d7cd8ff

      #=========================================================#
      # Layout Support:
      #=========================================================#
      # tile,scroller,grid,deck,monocle,center_tile,vertical_tile,vertical_scroller
      tagrule=id:1,layout_name:tile
      tagrule=id:2,layout_name:tile
      tagrule=id:3,layout_name:tile
      tagrule=id:4,layout_name:tile
      tagrule=id:5,layout_name:tile
      tagrule=id:6,layout_name:tile
      tagrule=id:7,layout_name:tile
      tagrule=id:8,layout_name:tile
      tagrule=id:9,layout_name:tile
      #=========================================================#
      # Cursor Size & Theme
      #=========================================================#
      cursor_size=48
      cursor_theme=Adwaita
      env=GTK_THEME,Adwaita:dark
      env=XCURSOR_SIZE,48
      env=GDK_SCALE,2

    '';
  };

  # autostart_sh = ''
  # '';
  # };
  home.file = {
    ".config/mango/autostart.sh".source = pkgs.writers.writeBash "autostart.sh" ''
      wl-paste --type text --watch cliphist store &
      wl-paste --type image --watch cliphist store &
      # xwayland-satellite &
      # awww-daemon &
      # battery-monitor &
      # darkman run &
      # swaync &
      mako &
      kanshi &
      # quickshell &
      waybar &
      wpaperd &
      # swayosd-server &
      # sunsetr &
    '';
    "Pictures/Wallpapers" = {
      source = inputs.wallpapers;
    };
    ".config/wpaperd/config.toml".text = ''
      [default]
       path = "/home/jr/Pictures/Wallpapers/"
       duration = "30m"
       transition-time = 600
    '';
  };
}
