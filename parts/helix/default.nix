{
  flake.homeModules.helix =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.custom.helix;
    in
    {
      options.custom.helix.enable = lib.mkEnableOption "Enable Helix Module";
      config = lib.mkIf cfg.enable {
        programs.helix = with pkgs; {
          enable = true;
          # package = inputs'.helix.packages.default;
          # package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.helix;
          defaultEditor = true;
          extraPackages = [
            marksman
            markdown-oxide
            markdownlint-cli
            markdownlint-cli2
            prettierd
            shfmt
            shellcheck
            nixd
            nixfmt
            nixpkgs-fmt
            nodejs_22
            nil
            # lua-language-server
            bash-language-server
            stylua
            jq
            # deadnix
            # alejandra
            # nixfmt-rfc-style
            biome
            clang-tools
            # helix-gpt
            # codeium
            nodePackages.prettier
            taplo
            vscode-langservers-extracted
            vscode-extensions.vadimcn.vscode-lldb
            lldb
            yaml-language-server
            wl-clipboard-rs
            scooter
            # simple-completion-language-server
            topiary
            # ltex-ls
            hunspell
            hunspellDicts.en_US
            harper
          ];
          settings = {
            # languages = import ./languages.nix;
            # theme = "rose_pine";
            theme = "tokyonight";
            # theme = "gruvbox";
            editor = {
              # shell = [
              #   "nu"
              #   "-c"
              # ];
              color-modes = true;
              cursorline = true;
              bufferline = "multiple"; # or "always"
              line-number = "relative";
              rulers = [
                80
                120
              ];
              true-color = true;
              default-yank-register = "+";
              soft-wrap = {
                enable = false;
                # max-wrap = 10;
                # max-indent-retain = 14;
                # wrap-at-text-width = true;
              };
              auto-save = {
                focus-lost = true;
                after-delay.enable = true;
              };
              cursor-shape = {
                insert = "bar";
                normal = "block";
                select = "underline";
              };
              file-picker = {
                hidden = false;
                ignore = false;
              };
              indent-guides = {
                character = "┊";
                render = true;
                skip-levels = 1;
              };
              end-of-line-diagnostics = "hint";
              inline-diagnostics.cursor-line = "warning";
              lsp = {
                display-inlay-hints = true;
                display-messages = true;
              };
              statusline = {
                left = [
                  "mode"
                  "spacer"
                  "diagnostics"
                  "spinner"
                  "file-name"
                ];
                right = [
                  "workspace-diagnostics"
                  "spacer"
                  "version-control"
                  "spacer"
                  "separator"
                  "selections"
                  "separator"
                  "position"
                  "position-percentage"
                  "spacer"
                ];
                mode.normal = "";
                mode.insert = "I";
                mode.select = "S";
              };
            };
            keys = {
              normal = {
                H = ":buffer-previous"; # Shift+H & Shift+L to cycle buffers
                L = ":buffer-next";
                space = {
                  "." = ":fmt";
                  t.s = ":toggle soft-wrap-enable";
                  e = [
                    ":sh rm -f /tmp/unique-file-h21a434"
                    ":insert-output yazi '%{buffer_name}' --chooser-file=/tmp/unique-file-h21a434"
                    ":insert-output echo \"x1b[?1049h\" > /dev/tty"
                    ":open %sh{cat /tmp/unique-file-h21a434}"
                    ":redraw"
                  ];
                  E = [
                    ":sh rm -f /tmp/unique-file-u41ae14"
                    ":insert-output yazi '%{workspace_directory}' --chooser-file=/tmp/unique-file-u41ae14"
                    ":insert-output echo \"x1b[?1049h\" > /dev/tty"
                    ":open %sh{cat /tmp/unique-file-u41ae14}"
                    ":redraw"
                  ];
                };
                C-g = [
                  ":write-all"
                  ":new"
                  ":insert-output lazygit"
                  ":buffer-close!"
                  ":redraw"
                  ":reload-all"
                ];
                C-r = [
                  ":write-all"
                  ":insert-output scooter >/dev/tty"
                  ":redraw"
                  ":reload-all"
                ];
                C-y = [
                  ":sh rm -f /tmp/unique-file"
                  ":insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file"
                  ":insert-output echo '\x1b[?1049h\x1b[?2004h' > /dev/tty"
                  ":open %sh{cat /tmp/unique-file}"
                  ":redraw"
                ];
                "p" = [
                  "paste_after"
                  "collapse_selection"
                ]; # Normal paste
                "P" = [
                  "paste_before"
                  "collapse_selection"
                ]; # Paste before
                "R" = "replace_with_yanked"; # Swap selection with clipboard
                # The "Guaranteed Line" Paste
                "C-p" = [
                  "open_below"
                  "paste_after"
                ];
              };
            };
          };
          languages = {
            language-server.biome = {
              command = "biome";
              args = [ "lsp-proxy" ];
            };

            language-server.rust-analyzer.config = {
              check = {
                command = "clippy";
              };
              check.features = "all";
              check.always = true;
              cargo.toolchain = "nightly";
              cargo.buildScripts.rebuildOnSave = true;
              cargo.buildScripts.enable = true;
              cargo.autoreload = true;
              cargo.procMacro.enable = true;
              cargo.procMacro.ignored.leptos_macro = [
                "server"
                "component"
              ];
              cargo.diagnostics.disables = [ "unresolved-proc-macro" ];
              cargo.allFeatures = true;
            };

            language-server.scls = {
              command = "simple-completion-language-server";
            };

            language-server.scls.config = {
              max_completion_items = 100;
              feature_words = true;
              feature_snippets = true;
              snippets_first = true;
              snippets_inline_by_word_tail = false;
              feature_unicode_input = false;
              feature_paths = true;
              feature_citations = false;
            };

            language-server.scls.environment = {
              RUST_LOG = "info,simple-completion-language-server=info";
              LOG_FILE = "/tmp/completion.log";
            };

            language-server.yaml-language-server.config.yaml.schemas = {
              kubernetes = "k8s/*.yaml";
            };

            language-server.harper-ls = {
              command = "harper-ls";
              args = [ "--stdio" ];
            };

            language-server.harper-ls.config.harper-ls = {
              diagnosticSeverity = "warning";
              linters.spaces = false;
            };

            language = [
              {
                name = "css";
                language-servers = [
                  "vscode-css-language-server"
                  "gpt"
                ];
                formatter = {
                  command = "prettier";
                  args = [
                    "--stdin-filepath"
                    "file.css"
                  ];
                };
                auto-format = false;
              }
              # {
              #   name = "go";
              #   language-servers = [ "gopls" "golangci-lint-lsp" "gpt" ];
              #   formatter = { command = "goimports"; };
              #   auto-format = true;
              # }
              {
                name = "html";
                language-servers = [
                  "vscode-html-language-server"
                  "gpt"
                ];
                formatter = {
                  command = "prettier";
                  args = [
                    "--stdin-filepath"
                    "file.html"
                  ];
                };
                auto-format = true;
              }
              {
                name = "json";
                language-servers = [
                  {
                    name = "vscode-json-language-server";
                    except-features = [ "format" ];
                  }
                  "biome"
                ];
                formatter = {
                  command = "biome";
                  args = [
                    "format"
                    "--indent-style"
                    "space"
                    "--stdin-file-path"
                    "file.json"
                  ];
                };
                auto-format = true;
              }
              {
                name = "jsonc";
                language-servers = [
                  {
                    name = "vscode-json-language-server";
                    except-features = [ "format" ];
                  }
                  "biome"
                ];
                formatter = {
                  command = "biome";
                  args = [
                    "format"
                    "--indent-style"
                    "space"
                    "--stdin-file-path"
                    "file.jsonc"
                  ];
                };
                file-types = [
                  "jsonc"
                  "hujson"
                ];
                auto-format = true;
              }
              {
                name = "markdown";
                text-width = 80;
                soft-wrap.wrap-at-text-width = true;
                language-servers = [
                  "marksman"
                  "markdown-oxide"
                  # "gpt"
                  # "codeium"
                  "harper-ls"
                  # "ltex-ls"
                ];
                formatter = {
                  command = "prettier";
                  args = [
                    "--parser"
                    "markdown"
                    "--prose-wrap"
                    "always"
                    # "--stdin-filepath"
                    # "file.md"
                  ];
                };
                auto-format = false;
              }
              {
                name = "nix";
                auto-format = true;
                language-servers = [
                  "nil"
                  "typos"
                  "nixd"
                  # "gpt"
                  # "codeium"
                ];
                file-types = [ "nix" ];
                formatter = {
                  command = "${pkgs.nixfmt}/bin/nixfmt";
                };
              }
              {
                name = "nu";
                auto-format = true;
                formatter = {
                  command = "topiary";
                  args = [
                    "format"
                    "--language"
                    "nu"
                  ];
                };
              }
              {
                name = "rust";
                language-servers = [
                  "scls"
                  "rust-analyzer"
                  "gpt"
                ];
                scope = "source.rust";
                injection-regex = "rs|rust";
                file-types = [ "rs" ];
                roots = [
                  "Cargo.toml"
                  "Cargo.lock"
                ];
                shebangs = [
                  "rust-script"
                  "cargo"
                ];
                formatter = {
                  command = "rustfmt";
                  args = [ "--edition=2024" ];
                };
                comment-tokens = [
                  "//"
                  "///"
                  "//!"
                ];
                auto-format = true;
              }
              {
                name = "git-commit";
                language-servers = [ "scls" ];
              }
              {
                name = "stub";
                scope = "text.stub";
                file-types = [ ];
                shebangs = [ ];
                roots = [ ];
                auto-format = false;
                language-servers = [ "scls" ];
              }
              {
                name = "scss";
                language-servers = [
                  "vscode-css-language-server"
                  "gpt"
                ];
                formatter = {
                  command = "prettier";
                  args = [
                    "--stdin-filepath"
                    "file.scss"
                  ];
                };
                auto-format = true;
              }
              {
                name = "toml";
                language-servers = [ "taplo" ];
                formatter = {
                  command = "taplo";
                  args = [
                    "fmt"
                    "-o"
                    "column_width=120"
                    "-"
                  ];
                };
                auto-format = true;
              }
              {
                name = "bash";
                language-servers = [
                  "bash-language-server"
                  # "gpt"
                  # "codeium"
                ];
                file-types = [ "sh" ];
              }
              {
                name = "yaml";
                language-servers = [ "yaml-language-server" ];
                formatter = {
                  command = "prettier";
                  args = [
                    "--stdin-filepath"
                    "file.yaml"
                  ];
                };
                auto-format = true;
              }
            ];
            # language-server.gpt = {
            #   command = "helix-gpt";
            #   args = [
            #     "--handler"
            #     "codeium"
            #   ];
            # };
            # language-server.codeium = {
            #   # Your Codeium handler
            #   command = "helix-gpt";
            #   args = [
            #     "--handler"
            #     "codeium"
            #   ];
            # };
          };
        };
        # themes = {
        #   # https://github.com/helix-editor/helix/blob/master/runtime/themes/gruvbox.toml
        #   gruvbox_community = {
        #     inherits = "gruvbox";
        #     "variable" = "blue1";
        #     "variable.parameter" = "blue1";
        #     "function.macro" = "red1";
        #     "operator" = "orange1";
        #     "comment" = "gray";
        #     "constant.builtin" = "orange1";
        #     "ui.background" = {};
        #   };
        # };
      };
    };
}
