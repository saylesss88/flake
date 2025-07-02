{pkgs, ...}: {
  services.greetd = {
    enable = true;
    vt = 3; # or your preferred VT
    settings = {
      default_session = {
        user = "greeter"; # recommended, see below
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      };
    };
    # This is the key line:
    stopPlymouth = true;
  };
}
