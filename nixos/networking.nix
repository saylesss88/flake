{
  pkgs,
  config,
  host,
  lib,
  options,
  ...
}: let
  cfg = config.custom.networking;
in {
  options.custom.networking = {
    enable = lib.mkEnableOption "Enable networking";
  };

  config = lib.mkIf cfg.enable {
    networking = {
      networkmanager = {
        enable = true;
        plugins = [];
      };
      hostName = "${host}";
      enableIPv6 = true;
      timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
      hosts = {
        "192.168.1.8" = ["aottr.local"];
      };
    };
    # cloudflare dns
    # environment.etc = {
    #   "resolv.conf".text = "nameserver 1.1.1.1\n";
    # };
    # networking.firewall = {
    #   enable = true;
    #   allowedTCPPorts = [22];
    # };

    environment.systemPackages = with pkgs; [
      traceroute
      speedtest-cli
      networkmanagerapplet
      ncftp
      dig
      xh
    ];
    programs.nm-applet.enable = true;
  };
}
