{
  config,
  pkgs,
  lib,
  ...
}: {
  containers.mdbook-host = {
    ephemeral = lib.mkDefault false;
    autoStart = true;
    privateNetwork = false; # Share host's network namespace

    config = {
      containerConfig,
      containerPkgs,
      ...
    }: {
      networking.useDHCP = lib.mkDefault true;

      services.httpd = {
        enable = true;
        adminAddr = "saylesss87@proton.me";

        virtualHosts."*:80" = {
          documentRoot = "/var/www/mdbook";
        };
      };

      networking.firewall.allowedTCPPorts = [80];

      environment.systemPackages = with containerPkgs; [];

      fileSystems."/var/www/mdbook" = {
        device = "/home/jr/nix-book/book";
        fsType = "bind";
        options = ["ro"];
      };

      users.users.root.initialHashedPassword = "$6$Ezuf26fZZ6d5eGR.$v7D.3xzY1r1q778ciEZV4bWed0Nw57OiSrgYxNAUVE12VTID1Xu7tsjQuKIWJb6WCp.RdAaUbgTP86qJnD2yR.";
      system.stateVersion = "25.05";
    };
  };
}
