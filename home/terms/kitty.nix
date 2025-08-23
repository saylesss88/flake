{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom.kitty;
in {
  options.custom.kitty = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Kitty Module";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font.name = "FiraCode Nerd Font Mono";
      # font.name = "JetBrains Mono";
      font.size = 12;
      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
        "ctrl+shift+/" = "show_scrollback";
        "ctrl+shift+." = "show_last_command_output";
        "ctrl+shift+;" = "move_tab_forward";
        "ctrl+shift+b" = "scroll_page_up";
        "ctrl+shift+f" = "scroll_page_down";
        "ctrl+shift+[" = "scroll_home";
        "ctrl+shift+]" = "scroll_end";
        "ctrl+shift+u" = "scroll_to_prompt -1";
        "ctrl+shift+d" = "scroll_to_prompt 1";
        "ctrl+shift+0" = "change_font_size current 14.0";
        "ctrl+shift+minus" = "change_font_size current -1";
        "ctrl+shift+equal" = "change_font_size current +1";
        "ctrl+shift+h" = "previous_tab";
        "ctrl+shift+l" = "next_tab";
        "ctrl+shift+r" = "set_tab_title";
      };
      themeFile = "gruvbox-dark";
      settings = {
        term = "xterm-256color";
        # shell = "${pkgs.nushell}/bin/nu";
        shell = "${pkgs.zsh}/bin/zsh";
        scrollback_lines = 10000;
        scrollback_pager = ''
          nvim -c "silent! w! /tmp/kitty_scrollback_buffer | exec 'te cat /tmp/kitty_scrollback_buffer -' | exec 'norm G' | bn | bd!"
        '';
        enabled_layouts = "horizontal,vertical";

        window_padding_width = 15;
        disable_ligatures = "always";

        tab_bar_style = "powerline";
        tab_powerline_style = "round";
        hide_window_decorations = "titlebar-only";
      };
      extraConfig = ''
        tab_bar_edge top
        tab_bar_style powerline
        enable_audio_bell no
        modify_font cell_height 150%
        # background_opacity 0.5
        cursor_shape_unfocused unchanged
        cursor_trail 1
        cursor_trail_decay 0.1 0.3
        cursor_trail_start_threshold 0
      '';
    };
  };
}
