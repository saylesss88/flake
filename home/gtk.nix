{
  pkgs,
  inputs,
  ...
}: {
  home.pointerCursor = {
    enable = true;
    package = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
    name = "BreezeX-RosePine-Linux"; # Or the specific name of the theme as packaged
    size = 24; # Optional: Set the cursor size
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };
  # dconf.settings = {
  #   "org/gnome/desktop/interface" = {
  #     color-scheme = "prefer-dark"; # or 'force-dark'
  #   };
  # };
}
