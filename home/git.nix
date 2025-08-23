{
  lib,
  config,
  pkgs,
  userVars ? {},
  ...
}: let
  cfg = config.custom.git;
in {
  options.custom.git = {
    # Changed from options.gitModule
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the git module";
    };

    userName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = userVars.gitUsername; # or "TSawyer87"; # Fallback to "TSawyer87" if userVars.gitUsername is undefined
      description = "Git user name";
    };

    userEmail = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = userVars.gitEmail; # or "sawyerjr.25@gmail.com"; # Fallback to email if userVars.gitEmail is undefined
      description = "Git user email";
    };

    aliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        ci = "commit";
        co = "checkout";
        st = "status";
        ac = "!git add -A && git commit -m ";
        br = "branch ";
        df = "diff";
        dc = "diff --cached";
        lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";
        compare-branches = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
        pr = "pull - -rebase ";
        p = "push ";
        ppr = "push - -set-upstream origin ";
        pf = "push --force-with-lease";
        l1 = "log --pretty=oneline";
        lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
        lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
        latest = "for-each-ref --sort=-taggerdate --format='%(refname:short)' --count=1";
        undo = "git reset --soft HEAD^";
        brd = "branch -D";
        grs = "!git fetch origin && git rebase origin/main";
        grsm = "!git fetch origin && git rebase origin/master";
        ri = "rebase -i HEAD~5";
        rb = "rebase";
        ff = "merge --ff-only";
      };
      description = "Git aliases";
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
      description = "Git ignore patterns";
    };

    extraConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {
        commit.gpgsign = true;
        # gpg.format = "ssh";
        user.signingkey = "0x095882C1A124CF15";
        extraConfig = {
          pull = {
            rebase = true;
            ff = "only";
          };
        };
        rebase = {
          stat = true;
          autoStash = true; # Auto stashes and unstashes local changes during rebase
          # autoSquash = true;
          updateRefs = true;
        };
        fetch = {
          prune = true; # Automatically delets remote-tracking branches that no longer exist
        };

        core = {
          editor = "hx";
          excludesfile = "~/.config/git/ignore";
          pager = "${lib.getExe pkgs.diff-so-fancy}";
        };
        pager = {
          diff = "${lib.getExe pkgs.diff-so-fancy}";
          log = "delta";
          reflog = "delta";
          show = "delta";
        };
        credential.helper = "store";
        color = {
          ui = true;
          pager = true;
          diff = "auto";
          branch = {
            current = "green bold";
            local = "yellow dim";
            remove = "blue";
          };
          showBranch = "auto";
          interactive = "auto";
          grep = "auto";
          status = {
            added = "green";
            changed = "yellow";
            untracked = "red dim";
            branch = "cyan";
            header = "dim white";
            nobranch = "white";
          };
        };
      };
      description = "Additional Git configuration";
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [lazygit delta];
      description = "Additional Git-related packages to install";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = cfg.packages;
    programs.gh = {
      enable = true;
      hosts = {
        "github.com" = {
          user = "saylesss88";
        };
      };
      gitCredentialHelper.enable = true;
      extensions = [pkgs.gh-notify];
      settings = {
        git_protocol = "ssh";
        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
      };
      settings = {
        editor = "hx";
      };
    };

    programs.git = {
      enable = true;
      lfs.enable = true;
      inherit (cfg) userName;
      inherit (cfg) userEmail;
      inherit (cfg) aliases;
      inherit (cfg) ignores;
      inherit (cfg) extraConfig;
    };
  };
}
