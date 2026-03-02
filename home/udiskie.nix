{ ... }:
{
  services.udiskie = {
    enable = true;
    settings = {
      program_options = {
        tray = true;
        automount = true;
        notify = true;
      };
    };
  };
}
