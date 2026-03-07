{
  flake.nixosModules.my-fonts =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.custom.my-fonts;
    in
    {
      options.custom.my-fonts.enable = lib.mkEnableOption "Enable Fonts Module";

      config = lib.mkIf cfg.enable {
        fonts = {
          # use fonts specified by user rather than default ones
          enableDefaultPackages = false;
          fontDir.enable = true;

          packages = with pkgs; [
            noto-fonts-color-emoji
            noto-fonts-cjk-sans
            font-awesome
            # symbola
            material-icons
            fira-code

            source-sans
            source-serif
            source-han-sans
            source-han-serif

            nerd-fonts.jetbrains-mono
            nerd-fonts.fira-code
            nerd-fonts.fira-mono
            nerd-fonts.iosevka
            nerd-fonts.symbols-only

            dejavu_fonts
          ];
          # user defined fonts
          # the reason there's Noto Color Emoji everywhere is to override DejaVu's
          # B&W emojis that would sometimes show instead of some Color emojis
          fontconfig.defaultFonts = {
            serif = [
              "Source Han Serif SC"
              "Source Han Serif TC"
              "Noto Fonts Color Emoji"
            ];
            sansSerif = [
              "Source Han Sans SC"
              "Source Han Sans TC"
              "Noto Fonts Color Emoji"
            ];
            monospace = [
              "JetBrainsMono Nerd Font"
              "Noto Fonts Color Emoji"
            ];
            emoji = [ "Noto Color Emoji" ];
          };
        };

        # https://wiki.archlinux.org/title/KMSCON
        services.kmscon = {
          # Use kmscon as the virtual console instead of gettys.
          # kmscon is a kms/dri-based userspace virtual terminal implementation.
          # It supports a richer feature set than the standard linux console VT,
          # including full unicode support, and when the video card supports drm should be much faster.
          enable = true;
          fonts = [
            {
              name = "Source Code Pro";
              package = pkgs.source-code-pro;
            }
          ];
          extraOptions = "--term xterm-256color";
          extraConfig = "font-size=14";
          # Whether to use 3D hardware acceleration to render the console.
          hwRender = true;
        };
      };
    };
}
