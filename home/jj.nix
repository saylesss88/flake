{
  lib,
  config,
  pkgs,
  # userVars ? {},
  ...
}: let
  cfg = config.custom.jj;
in {
  options.custom.jj = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the Jujutsu (jj) module";
    };

    userName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "saylesss88";
      description = "Jujutsu user name";
    };

    userEmail = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "saylesss87@proton.me";
      description = "Jujutsu user email";
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [lazyjj meld];
      description = "Additional Jujutsu-related packages to install";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {
        ui = {
          default-command = ["status"];
          diff-editor = ["nvim" "-c" "DiffEditor" "$left" "$right" "$output"];
          merge-editor = ":builtin";
        };
        git = {
          auto-local-bookmark = true;
        };
        aliases = {
          tug = ["bookmark" "move" "--from" "heads(::@- & bookmarks())" "--to" "@-"];
          upmain = ["bookmark" "set" "main"];
          squash-desc = ["squash" "::@" "-d" "@"];
          rebase-main = ["rebase" "-d" "main"];
          amend = ["describe" "-m"];
          pushall = ["git" "push" "--all"];
          dmain = ["diff" "-r" "main"];
          l = ["log" "-T" "short"];
        };
      };
      description = "Jujutsu configuration settings";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = cfg.packages;

    programs.jujutsu = {
      enable = true;
      settings = lib.mergeAttrs cfg.settings {
        user = {
          name = cfg.userName;
          email = cfg.userEmail;
        };
      };
    };
  };
}
