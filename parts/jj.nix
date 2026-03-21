{
  flake.homeModules.jj =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.custom.jj;
    in
    {
      options.custom.jj.enable = lib.mkEnableOption "Enable jj module";

      config = lib.mkIf cfg.enable {
        programs.jujutsu = {
          enable = true;
          settings = {
            user = {
              name = "saylesss88";
              email = "saylesss87@proton.me";
            };
            ui = {
              default-command = [
                "log"
                "--no-pager"
              ];
              diff-editor = "gitpatch";
              merge-editor = ":builtin";
              conflict-marker-style = "diff";
            };

            bookmarks = {
              push-on-new = true;
            };
            revset-aliases = {
              "closest_bookmark(to)" = "heads(::to & bookmarks())";
              "immutable_heads()" = "builtin_immutable_heads() | remote_bookmarks()";
              # "recent()" = "committer_date(after: '1 month ago')";
              # This finds all ancestors of the current head, limited to 50 revisions
              "recent()" = "latest(mine(), 10)";
              trunk = "main@origin";
            };
            template-aliases = {
              "format_short_change_id(id)" = "id.shortest()";
            };
            merge-tools.gitpatch = {
              program = "sh";
              edit-args = [
                "-c"
                ''
                  set -eu
                  rm -f "$right/JJ-INSTRUCTIONS"
                  git -C "$left" init -q
                  git -C "$left" add -A
                  git -C "$left" commit -q -m baseline --allow-empty
                  mv "$left/.git" "$right"
                  git -C "$right" add --intent-to-add -A
                  git -C "$right" add -p
                  git -C "$right" diff-index --quiet --cached HEAD && { echo "No changes done, aborting split."; exit 1;}
                  git -C "$right" commit -q -m split
                  git -C "$right" restore .  # undo changes in modified files
                  git -C "$right" reset .    # undo --intent-to-add
                  git -C "$right" clean -q -df  # remove untracked files
                ''
              ];
            };
            aliases = {
              c = [ "commit" ];
              ci = [
                "commit"
                "--interactive"
              ];
              e = [ "edit" ];
              i = [
                "git"
                "init"
                "--colocate"
              ];
              tug = [
                "bookmark"
                "move"
                "--from"
                "closest_bookmark(@-)"
                "--to"
                "@-"
              ];
              mb = [
                "bookmark"
                "set"
                "main"
                "-r"
                "@"
              ];
              mp = [
                "bookmark"
                "set"
                "main"
                "-r"
                "@-"
              ];
              # Only shows the current working copy, main, and their ancestors
              l = [
                "log"
                "-r"
                "trunk()..@"
              ];
              ll = [
                "log"
                "-r"
                "trunk()..@ | (trunk()..main) | trunk() | (trunk()-..trunk())"
              ];
              # Shows everything that isn't abandoned
              la = [
                "log"
                "-r"
                "all()"
              ];
              log-recent = [
                "log"
                "-r"
                "default() & recent()"
              ];
              nb = [
                "bookmark"
                "create"
                "-r"
                "@-"
              ];
              upmain = [
                "bookmark"
                "set"
                "main"
              ];
              squash-desc = [
                "squash"
                "::@"
                "-d"
                "@"
              ];
              rebase-main = [
                "rebase"
                "-d"
                "main"
              ];
              amend = [
                "describe"
                "-m"
              ];
              pushall = [
                "git"
                "push"
                "--all"
              ];
              r = [ "rebase" ];
              s = [ "squash" ];
              si = [
                "squash"
                "--interactive"
              ];
              finish-feat = [
                "do"
                "--"
                "rebase"
                "-b"
                "@-"
                "-d"
                "main"
                "||"
                "bookmark"
                "set"
                "main"
                "-r"
                "@-"
              ];
            };
          };
        };
      };
    };
}
