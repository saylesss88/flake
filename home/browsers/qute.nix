{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.custom.qutebrowser;
in {
  options.custom.qutebrowser = {
    enable = lib.mkEnableOption "Enable qutebrowser module";
    userStyles = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Custom CSS for qutebrowser.";
    };
    dictionaryLanguages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["en-US"];
      description = "Spellcheck dictionary languages to auto-install.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.python3Packages.adblock];
    programs.qutebrowser = {
      enable = true;

      extraConfig = ''
        config.set('colors.webpage.darkmode.enabled', False, 'file://*')
        config.set('colors.webpage.darkmode.enabled', False, 'https://docs.google.com/*')
        config.set('colors.webpage.darkmode.enabled', False, 'https://app.diagrams.net/*')
        config.set('colors.webpage.darkmode.enabled', False, 'https://excalidraw.com/*')
        config.set('colors.webpage.darkmode.enabled', False, 'https://app.powerbi.com/*')

        # privacy
        config.set("content.webgl", False, "*")
        config.set("content.canvas_reading", False)
        config.set("content.geolocation", False)
        config.set("content.webrtc_ip_handling_policy", "default-public-interface-only")
        config.set("content.cookies.accept", "all")
        config.set("content.cookies.store", True)
      '';

      settings = {
        colors.webpage.darkmode = {
          enabled = true;
          algorithm = "lightness-cielab";
          policy.images = "never";
        };
        fonts = {
          default_size = "16px";
          default_family = "JetBrainsMono Nerd Font";
        };
        auto_save.session = true;
        spellcheck.languages = ["en-US"];
      };
      searchEngines = {
        DEFAULT = "https://duckduckgo.com/?ia=web&q={}";
        yt = "https://www.youtube.com/results?search_query={}";
        search = "https://search.nixos.org/packages?channel=unstable&type=packages&query={}";
        hm = "https://home-manager-options.extranix.com/?query={}&release=master";
        "!gist" = "https://gist.github.com/search?q={}";
        "!aw" = "https://wiki.archlinux.org/?search={}";
        nw = "https://wiki.nixos.org/wiki/NixOS_Wiki/?search={}";
        re = "https://www.reddit.com/r/{}";
      };
      quickmarks = {
        bw = "https://vault.bitwarden.com/#/vault";
        gm = "https://mail.google.com/mail/u/0/#inbox";
        gem = "https://gemini.google.com/app/";
        mdbook = "https://saylesss88.github.io/";
        gh = "https://github.com";
        perp = "https://perplexity.ai/";
      };
    };

    # xdg.configFile."qutebrowser" = {
    #   source = "${inputs.self}/config/qutebrowser";
    #   recursive = true;
    # };

    xdg.dataFile."qutebrowser/userstyles.css" = lib.mkIf (cfg.userStyles != "") {
      text = cfg.userStyles;
    };

    home.activation = {
      qbCreateDownloadDir = config.lib.dag.entryAnywhere ''
        [ ! -d "$HOME/Downloads" ] && mkdir "$HOME/Downloads"
      '';
      qbInstallDicts = config.lib.dag.entryAnywhere (
        lib.concatStringsSep "\n" (map (lang: ''
            if ! find "${config.xdg.dataHome}/qutebrowser/qtwebengine_dictionaries" \
                 -type d -maxdepth 1 -name "${lang}*" 2>/dev/null | grep -q .; then
              ${pkgs.python3}/bin/python ${pkgs.qutebrowser}/share/qutebrowser/scripts/dictcli.py install ${lang}
            fi
          '')
          cfg.dictionaryLanguages)
      );
    };
  };
}
