{
  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "sidebar.verticalTabs" = true;
      };
      userChrome = builtins.readFile ./userChrome.css;
      userContent = builtins.readFile ./userContent.css;
    };
    policies = {
      ExtensionSettings = {
        "*".installation_mode = "blocked"; # Block all except allowed
        # Vimium-FF extension:
        "vimiumff@vimium.github.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
          installation_mode = "force_installed";
        };
        # uBlock Origin:
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Privacy Badger:
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
