{lib, ...}: {
  containers.mdbook-host = {
    autoStart = true;
    ephemeral = true;
    privateNetwork = false; # Use the hosts network

    bindMounts."/var/www/mdbook" = {
      hostPath = "/home/jr/nix-book/book";
      isReadOnly = true;
    };

    config = {containerPkgs, ...}: {
      networking.useDHCP = lib.mkDefault true;

      services.httpd = {
        enable = true;
        adminAddr = "yourEmail.com";
        virtualHosts."localhost" = {
          documentRoot = "/var/www/mdbook";
          serverAliases = [];
        };
      };

      networking.firewall.allowedTCPPorts = [80];
      environment.systemPackages = with containerPkgs; [];
      system.stateVersion = "25.05";
    };
  };
}
