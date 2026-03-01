{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.custom.git;
in {
  options.custom.git = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable custom Git configuration.";
    };

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
        "/result"
        "/nix/store"
        "/nix/var/nix/profiles"
        "/vm-state"
        "/vm-config"
        "vm-image.qcow2"
        ".bash_history"
        "wallpapers/*"
      ];
      description = "Global gitignore patterns.";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "All Git config: user, aliases, pull, color, etc.";
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [lazygit delta];
      description = "Extra Git tools.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = cfg.packages;

    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      extensions = [pkgs.gh-notify];
      settings = {
        git_protocol = "ssh";
        editor = "hx";
        aliases = {
          s = "status";
          co = "checkout";
          # Create branch & switch to it
          cob = "checkout -b";
          # Delete a branch
          del = "branch -D";
          pv = "view";
          br = "branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate";
          save = "!git add -A && git commit -m 'chore: commit save point'";
          # Rollback changes (place back in staging area)
          undo = "reset HEAD~1 --mixed";
          # Clean all changes
          res = "!git reset --hard";
          lg = "    lg = !git log --pretty=format:\"%C(magenta)%h%Creset -%C(red)%d%Creset %s %C(dim green)(%cr) [%an]\" --abbrev-commit -30";
        };
      };
      hosts."github.com".user = cfg.settings.user.name or "saylesss88";
    };

    programs.git = {
      enable = true;
      lfs.enable = true;
      inherit (cfg) ignores;

      # Only one `settings` — merge defaults + user config
      settings = lib.mkMerge [
        {
          user.name = "saylesss88";
          user.email = "saylesss87@proton.me";
        }
        cfg.settings # User can override anything
      ];
    };
  };
}
