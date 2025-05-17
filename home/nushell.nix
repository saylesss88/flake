{
  pkgs,
  lib,
  colorscheme,
  ...
}: {
  config = {
    programs = {
      carapace.enable = true;
      carapace.enableNushellIntegration = true;
      atuin.enable = true;
      atuin.enableNushellIntegration = true;
      direnv = {
        enable = true;
        enableNushellIntegration = true;
        nix-direnv.enable = true;
      };

      nushell = {
        enable = true;
        configFile.source = ./shells/nushell/config.nu;
      };
    };

    #  Use xdg.configFile to create style.nu
    xdg.configFile."nushell/style.nu".text = let
      colorscheme = "tokyonight_night";
      cs = import ./colorscheme.nix { inherit colorscheme; };
      colorscheme-dash = builtins.replaceStrings ["_"] ["-"] colorscheme;
    in ''
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

          let dev_tag = if (
            $nu.current-exe == (which nu).path.0
            or $nu.current-exe == '${pkgs.nushell}/bin/nu'
          ) { "" } else ' '
          $env.PROMPT_INDICATOR = {|| "> " }
          $env.PROMPT_INDICATOR_VI_INSERT = {|| prompt_decorator "${cs.black}" "${cs.light_green}" ($dev_tag + "󰏫") }
          $env.PROMPT_INDICATOR_VI_NORMAL = {|| prompt_decorator "${cs.black}" "${cs.yellow}" ($dev_tag + "") }
          $env.LS_COLORS = (vivid generate ${colorscheme-dash} | str trim)
          $env.FZF_DEFAULT_OPTS = (
            "--layout reverse --header-first --tmux center,80%,60% "
            + "--pointer ▶ --marker 󰍕 --preview-window right,65% "
            + "--bind 'bs:backward-delete-char/eof,tab:accept-or-print-query,ctrl-t:toggle+down,ctrl-s:change-multi' "
            + $"--prompt '(prompt_decorator '${cs.black}' '${cs.green}' '▓▒░ ' false)' "
            + "--color=fg:${cs.white},hl:${cs.red} "
            + "--color=fg+:${cs.cyan},bg+:${cs.black},hl+:${cs.red} "
            + "--color=info:${cs.blue},prompt:${cs.yellow},pointer:${cs.red} "
            + "--color=marker:${cs.white},spinner:${cs.green},header:${cs.white}"
          )
        '';

        shellAliases = let
          g = lib.getExe pkgs.git;
          c = "cargo";
        in {
          # Cargo
          cb = "${c} build";
          cc = "${c} check";
          cn = "${c} new";
          cr = "${c} run";
          cs = "${c} search";
          ct = "${c} test";
          repl = "evcxr";

          # Git
          ga = "${g} add";
          gc = "${g} commit";
          gd = "${g} diff";
          gl = "${g} log";
          gs = "${g} status";
          gp = "${g} push origin main";

          # ETC.
          c = "clear";
          yz = "${pkgs.yazi}/bin/yazi";
          la = "ls -la";
          ll = "ls -l";
          n = "${pkgs.nitch}/bin/nitch";
          vi = "nvim";
          zd = "zeditor";
          fz = "fzf --bind 'enter:become(hx {})'";
          powersave = "sudo cpupower frequency-set -g powersave";
          performance = "sudo cpupower frequency-set -g performance";
          zi = "__zoxide_zi";

          # Nix
          # fr = "nh os switch --hostname magic /home/jr/flakes";
          fr = "nh os switch /home/jr/flake";
          ft = "nh os test /home/jr/flake";
          fu = "nh os switch --update /home/jr/flake";
          upd = "nix-upgrade";
          cleanup = "nh clean all";
          opts = "man home-configuration.nix";

          cat = "${pkgs.bat}/bin/bat";
          df = "${pkgs.duf}/bin/duf";
          find = "${pkgs.fd}/bin/fd";
          # grep = "${pkgs.ripgrep}/bin/rg";
          grep = "batgrep";
          tree = "${pkgs.eza}/bin/eza --git --icons --tree";
        };

        environmentVariables = {
          STARSHIP_SHELL = "nu";
          PROMPT_INDICATOR = "";
          PROMPT_INDICATOR_VI_INSERT = ": ";
          PROMPT_INDICATOR_VI_NORMAL = "> ";
          PROMPT_MULTILINE_INDICATOR = "::: ";
          DIRENV_LOG_FORMAT = ''""''; # make direnv quiet
          # SHELL = ''"${pkgs.nushell}/bin/nu"'';
          # EDITOR = ''"hx"'';
          EDITOR = "hx";
          VISUAL = "hx";
          MANPAGER = "nvim +Man!";
        };

        # See the Nushell docs for more options.
        extraConfig = let
          conf = builtins.toJSON {
            show_banner = false;
            edit_mode = "vi";
            # completions.external.completer = {|span| carapace_by_fzf $span };
            # shell_integration = true;

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

            menus = [
              # {
              #   name = "my_history_menu";
              #   only_buffer_difference = false;
              #   marker = "";
              #   # type = {layout = ide};
              # }
              {
                name = "completion_menu";
                only_buffer_difference = false;
                marker = "? ";
                type = {
                  layout = "columnar"; # list, description
                  columns = 4;
                  col_padding = 2;
                };
                style = {
                  text = "magenta";
                  selected_text = "blue_reverse";
                  description_text = "yellow";
                };
              }
            ];
          };
          completion = name: ''
            source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu
          '';
          completions = names:
            builtins.foldl' (prev: str: ''
              ${prev}
              ${str}'') "" (map completion names);
        in ''
                      $env.config = ${conf};
                      ${completions [
            "git"
            "nix"
            "man"
            "cargo"
            "just"
          ]}

          def --env yy [...args] {
          	let tmp = (mktemp -t "yazi-cwd.XXXXX")
          	yazi ...$args --cwd-file $tmp
          	let cwd = (open $tmp)
          	if $cwd != "" and $cwd != $env.PWD {
          		cd $cwd
          	}
          	rm -fp $tmp
          }
        '';
      };
    };
  };
}
