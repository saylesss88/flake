_: {
  programs = {
    gh.enable = true;
    man.enable = true;
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };

    zathura = {
      enable = true;
    };

    go = {
      enable = true;
    };

    # nix-index = { enable = true; }; # nix-locate
  };
}
