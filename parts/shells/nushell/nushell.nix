{
  flake.homeModules.nushell =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.custom.nushell;
      colorCfg = config.custom.terminal.colors;

      # Manual import of the helper logic (now safely hidden from scanners)
      themeHelper = import ./colorscheme.nix_helper;
      cs = themeHelper {
        inherit lib;
        colorscheme = colorCfg.scheme;
        xargb = colorCfg.xargb;
        alpha = colorCfg.alpha;
      };

      colorscheme-dash = builtins.replaceStrings [ "_" ] [ "-" ] colorCfg.scheme;
    in
    {
      options.custom = {
        nushell.enable = lib.mkEnableOption "Enable Nushell Module";
        terminal.colors = {
          scheme = lib.mkOption {
            type = lib.types.str;
            default = "tokyonight_night";
          };
          xargb = lib.mkEnableOption "Use XARGB format";
          alpha = lib.mkOption {
            type = lib.types.str;
            default = "ff";
          };
        };
      };
      config = lib.mkIf cfg.enable {
        programs = {
          carapace.enable = true;
          carapace.enableNushellIntegration = true;
          atuin.enable = false;
          # atuin.enableNushellIntegration = true;
          direnv.enable = true;
          direnv.enableNushellIntegration = true;
          direnv.nix-direnv.enable = true;

          nushell = {
            enable = true;
            configFile.source = ./config/config.nu;
            extraConfig =
              let
                conf = builtins.toJSON {
                  show_banner = false;
                  edit_mode = "vi";
                  # Injecting your calculated theme into Nushell's core engine
                  color_config = cs;
                  ls.clickable_links = true;
                  rm.always_trash = true;
                  table = {
                    mode = "rounded";
                    index_mode = "always";
                    header_on_separator = false;
                  };
                  cursor_shape = {
                    vi_insert = "line";
                    vi_normal = "block";
                  };
                };
                completion =
                  name:
                  "source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu";
                completions = names: lib.concatStringsSep "\n" (map completion names);
              in
              ''
                $env.config = ${conf}
                ${completions [
                  "git"
                  "nix"
                  "man"
                  "cargo"
                  "just"
                ]}
              '';

            shellAliases = {
              # ... your aliases stay as they are ...
              cat = "${pkgs.bat}/bin/bat";
              tree = "${pkgs.eza}/bin/eza --git --icons --tree";
              y = "${pkgs.yazi}/bin/yazi";
            };
          };
        };

        home.sessionVariables = {
          EDITOR = "hx";
          VISUAL = "hx";
          MANPAGER = "nvim +Man!";
        };

        xdg.configFile."nushell/style.nu".text = ''
          def prompt_decorator [
            font_color: string
            bg_color: string
            symbol: string
            with_starship?: bool = true
          ] {
            let bg1 = if $with_starship { '${cs.white}' } else $bg_color
            let fg = {fg: $bg_color}
            let bg = {fg: $font_color bg: $bg_color}
            let startship_leading = if $with_starship { $"(ansi --escape {fg: $bg_color bg: $bg1})" } else ""
            $"($startship_leading)(ansi --escape $bg)($symbol)(ansi reset)(ansi --escape $fg)(ansi reset) "
          }

          $env.PROMPT_INDICATOR = {|| "> " }
          $env.PROMPT_INDICATOR_VI_INSERT = {|| prompt_decorator "${cs.black}" "${cs.light_green}" "󰏫" }
          $env.PROMPT_INDICATOR_VI_NORMAL = {|| prompt_decorator "${cs.black}" "${cs.yellow}" "" }

          $env.LS_COLORS = (try { ${pkgs.vivid}/bin/vivid generate ${colorscheme-dash} | str trim } catch { "" })

          $env.FZF_DEFAULT_OPTS = (
            "--layout reverse --header-first "
            + "--color=fg:${cs.white},hl:${cs.red} "
            + "--color=fg+:${cs.cyan},bg+:${cs.black},hl+:${cs.red} "
            + "--color=info:${cs.blue},prompt:${cs.yellow},pointer:${cs.red} "
            + "--color=marker:${cs.white},spinner:${cs.green},header:${cs.white}"
          )
        '';
      };
    };
}
