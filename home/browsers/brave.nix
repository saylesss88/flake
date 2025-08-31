{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.custom.brave;
in {
  options.custom.brave = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Brave";
    };
  };

  config = mkIf cfg.enable {
    # This attribute is for system-level package installations
    home.packages = [
      (pkgs.makeDesktopItem {
        name = "brave-private";
        desktopName = "Brave Web Browser (Private)";
        genericName = "Launch a Private Brave-browser Instance";
        icon = "brave";
        exec = "${pkgs.brave}/bin/brave --incognito";
        categories = ["Network"];
      })
    ];

    # Brave has its own configuration module and extensions
    programs.brave = {
      enable = true;
      # You can specify the Brave extensions here
      extensions = [
        {id = "jhnleheckmknfcgijgkadoemagpecfol";} # Auto-Tab-Discard
        {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # Dark-Reader
        {id = "ldpochfccmkkmhdbclfhpagapcfdljkj";} # Decentraleyes
        {id = "bkdgflcldnnnapblkhphbgpggdiikppg";} # DuckDuckGo
        {id = "iaiomicjabeggjcfkbimgmglanimpnae";} # Tab-Session-Manager
        {id = "hipekcciheckooncpjeljhnekcoolahp";} # Tabliss
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # Ublock-Origin
        {id = "jinjaccalgkegednnccohejagnlnfdag";} # Violentmonkey
        {
          id = "dcpihecpambacapedldabdbpakmachpb";
          updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/src/updates/updates.xml";
        }
      ];
    };
  };
}
