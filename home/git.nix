{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.custom.git;
in
{
  options.custom.git = {
    enable = lib.mkEnableOption "custom Git configuration";

    ignores = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "*.jj"
        "*.drv"
        "*.out"
        "*.log"
        ".direnv/"
        ".cache/"
        ".envrc"
        "/target"
        "result"
        "result-*"
        "/nix/store"
      ];
      description = "Global gitignore patterns.";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Extra Git configuration for extraConfig.";
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        lazygit
        delta
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = cfg.packages;

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };
    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      settings = {
        git_protocol = "ssh";
        editor = "hx";
      };
    };

    programs.git = {
      enable = true;

      lfs.enable = true;
      inherit (cfg) ignores;

      settings = lib.mkMerge [
        {
          pull.rebase = true;
          rebase = {
            autoStash = true;
            autoSquash = true;
          };
          alias = {
            s = "status";
            co = "checkout";
            cob = "checkout -b";
            del = "branch -D";
            # Fixed the 'lg' alias here
            lg = "log --pretty=format:'%C(magenta)%h%Creset -%C(red)%d%Creset %s %C(dim green)(%cr) [%an]' --abbrev-commit -30";
            save = "!git add -A && git commit -m 'chore: commit save point'";
            undo = "reset HEAD~1 --mixed";
            res = "!git reset --hard";
          };
          # Standard Home Manager identity fields
          user.name = "saylesss88";
          user.email = "saylesss87@proton.me";
        }
        cfg.settings
      ];
    };
  };
}
