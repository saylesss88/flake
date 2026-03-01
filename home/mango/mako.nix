{ ... }:
{
  services.mako = {
    enable = true;
    settings = {
      actions = true;
      anchor = "top-right";
      background-color = "#1F1F28"; # Kanagawa Dragon: Sumi Ink 0
      border-color = "#7E7C81"; # Kanagawa Dragon: Gray
      # background-color = "#000000";
      # border-color = "#FFFFFF";
      border-radius = 10;
      default-timeout = 10000;
      font = "monospace 10";
      height = 100;
      width = 300;
      icons = true;
      ignore-timeout = false;
      layer = "top";
      margin = 10;
      markup = true;
    };
  };
}
