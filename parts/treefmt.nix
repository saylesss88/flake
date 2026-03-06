{
  perSystem = _: {
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        deadnix.enable = true;
        statix.enable = true;
        keep-sorted.enable = true;
        nixfmt = {
          enable = true;
          # package = pkgs.nixfmt;
        };
      };

      settings = {
        global.excludes = [
          "LICENSE"
          "README.md"
          ".adr-dir"
          "nu_scripts"
          "*.{gif,png,svg,tape,mts,lock,mod,sum,toml,env,envrc,gitignore,sql,conf,pem,key,pub,py,narHash}"
          "Cargo.lock"
          "flake.lock"
          "justfile"
          ".jj/*"
        ];

        formatter = {
          nixfmt.priority = 1;
          statix.priority = 2;
          deadnix.priority = 3;
        };
      };
    };
  };
}
