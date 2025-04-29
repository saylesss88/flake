{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
with lib; {
  options = {
    stylixModule = {
      enable = mkEnableOption "Enables Stylix module.";
      base16Scheme = mkOption {
        type = types.attrs;
        default = {
          # Ayu Dark
          base00 = "0F1419";
          base01 = "131721";
          base02 = "272D38";
          base03 = "3E4B59";
          base04 = "BFBDB6";
          base05 = "E6E1CF";
          base06 = "E6E1CF";
          base07 = "F3F4F5";
          base08 = "F07178";
          base09 = "FF8F40";
          base0A = "FFB454";
          base0B = "B8CC52";
          base0C = "95E6CB";
          base0D = "59C2FF";
          base0E = "D2A6FF";
          base0F = "E6B673";
        };
        description = "Defines the Base16 color scheme used for Stylix.";
      };
    };
  };

  config = mkIf config.stylixModule.enable {
    stylix = {
      enable = true;
      image = "${inputs.wallpapers}/Lofi-Cafe1.png";
      inherit (config.stylixModule) base16Scheme;
      polarity = "dark";
      opacity.terminal = 0.8;
      cursor = {
        package = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
        name = "BreezeX-RosePine-Linux";
        size = 26;
      };
      fonts = {
        monospace = {
          package = lib.mkDefault pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrains Mono";
        };
        sansSerif = {
          package = pkgs.montserrat;
          name = "Montserrat";
        };
        serif = {
          package = pkgs.montserrat;
          name = "Montserrat";
        };
        sizes = {
          applications = lib.mkDefault 12;
          terminal = lib.mkDefault 12;
          desktop = 11;
          popups = 12;
        };
      };
    };
  };
}
