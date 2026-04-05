{ pkgs, lib, ... }:
{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "toml"
      "rust"
      "make"
    ];

    userSettings = {
      assistant = {
        enabled = true;
        version = "2";
        default_open_ai_model = null;

        default_model = {
          provider = "zed.dev";
          model = "claude-3-5-sonnet-latest";
        };

        inline_alternatives = [
          {
            provider = "copilot_chat";
            model = "gpt-4o";
          }
        ];
      };

      edit_predictions = {
        provider = "copilot";
        mode = "eager";
      };

      hour_format = "hour12";
      auto_update = false;
      helix_mode = true;
      load_direnv = "shell_hook";
      base_keymap = "VSCode";

      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = false;
        dock = "bottom";
        detect_venv = {
          on = {
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
            activate_script = "default";
          };
        };
        env = {
          TERM = "ghostty";
        };
        font_family = "FiraCode Nerd Font";
        font_features = null;
        font_size = null;
        line_height = "comfortable";
        option_as_meta = false;
        button = false;
        shell = {
          program = "zsh";
        };
        toolbar = {
          title = true;
        };
        working_directory = "current_project_directory";
      };

      lsp = {
        rust-analyzer = {
          binary = {
            path_lookup = true;
            # If you want Zed to use a project-specific rust-analyzer later,
            # replace this with a fixed path.
          };

          initialization_options = {
            checkOnSave = true;
            cargo = {
              allTargets = true;
            };
            check = {
              command = "clippy";
            };
          };
        };

        nix = {
          binary = {
            path_lookup = true;
          };
        };
      };

      languages = {
        Rust = {
          format_on_save = "on";
          language_servers = [ "rust-analyzer" ];
          formatter = {
            external = {
              command = "rustfmt";
              arguments = [
                "--edition"
                "2024"
              ];
            };
          };
        };
      };

      theme = {
        mode = "system";
        light = "One Light";
        dark = "Tokyo Night";
      };

      show_whitespaces = "all";
      ui_font_size = 16;
      buffer_font_size = 16;
    };
  };

  home.packages = with pkgs; [
    rust-analyzer
    rustfmt
    clippy
  ];
}
