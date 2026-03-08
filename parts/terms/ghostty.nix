{
  flake.homeModules.ghostty =
    {
      pkgs,
      lib,
      config,
      inputs',
      self',
      ...
    }:
    let
      cfg = config.custom.ghostty;
    in
    {
      options.custom.ghostty.enable = lib.mkEnableOption "Enable GhosTTY Module";

      config = lib.mkIf cfg.enable {

        programs.ghostty = {
          # package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          installVimSyntax = true;
          settings = {
            gtk-titlebar = false;
            # "config-file" = "/home/jr/.config/randpaper/themes/ghostty.config";
            # theme = "/home/jr/.config/randpaper/themes/ghostty.config";
            theme = "TokyoNight";
            keybind = [
              "alt+one=goto_tab:1"
              "alt+two=goto_tab:2"
              "alt+three=goto_tab:3"
              "alt+four=goto_tab:4"
              "alt+five=goto_tab:5"
              "alt+six=goto_tab:6"
              "ctrl+enter=toggle_fullscreen"
              "ctrl+shift+q=close_window"
            ];
            font-size = lib.mkForce 12;
            font-family = "Fira-Code-Mono Nerd Font";
            window-decoration = false;
            confirm-close-surface = false;
            cursor-style = "block";
            cursor-style-blink = false;

            unfocused-split-opacity = "0.9";
            background-opacity = "0.95";
            background-blur-radius = "20";
            # command = "${pkgs.nushell}/bin/nu";
            command = "${pkgs.zsh}/bin/zsh";

            window-theme = "dark";

            # Disables ligatures
            font-feature = [
              "-liga"
              "-dlig"
              "-calt"
            ];
          };
        };
      };
    };
}
