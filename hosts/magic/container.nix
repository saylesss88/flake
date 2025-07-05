# modules/containers/mdbook-host.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  containers.mdbook-host = {
    ephemeral = lib.mkDefault false;
    autoStart = true;

    config = {
      containerConfig,
      containerPkgs,
      ...
    }: {
      # networking.enableDNS = true;
      networking.useDHCP = lib.mkDefault true;

      services.httpd = {
        enable = true;
        adminAddr = "saylesss87@proton.me"; # <<-- REPLACE THIS
        documentRoot = "/var/www/mdbook";
      };

      networking.firewall.allowedTCPPorts = [80];

      environment.systemPackages = with containerPkgs; []; # No packages needed for static site

      # --- VERY IMPORTANT FOR YOUR MDBOOK TO BE SERVED ---
      # This mounts your built mdBook directory from your host into the container.
      # Replace /home/youruser/path/to/your/mdbook/book with the *actual path* to your built mdBook's output folder on your host.
      # For example, if your mdBook source is in ~/my-project/mdbook-src, and you run 'mdbook build',
      # the output HTML will typically be in ~/my-project/mdbook-src/book. You'd point to that 'book' directory.
      fileSystems."/var/www/mdbook" = {
        device = "/home/jr/nix-book"; # <<-- REPLACE THIS PATH
        fsType = "bind";
        options = ["ro"]; # Read-only access
      };

      users.users.root.initialHashedPassword = "$6$Ezuf26fZZ6d5eGR.$v7D.3xzY1r1q778ciEZV4bWed0Nw57OiSrgYxNAUVE12VTID1Xu7tsjQuKIWJb6WCp.RdAaUbgTP86qJnD2yR.";
      system.stateVersion = "25.05";
    };
  };
}
