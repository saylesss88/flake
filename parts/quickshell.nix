{
  flake.nixosModules.quickshell =
    {
      pkgs,
      config,
      lib,
      inputs,
      username,
      ...
    }:
    let
      cfg = config.custom.quickshell;
      quickshellPkg = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      options.custom.quickshell = {
        enable = lib.mkEnableOption "Enable Quickshell module";
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
          # Qt6 dependencies for quickshell
          qt6.qtbase
          qt6.qtdeclarative
          qt6.qtwayland
          qt6.qtsvg
          qt6.qtmultimedia
        ];

        # necessary environment variables for QML module resolution
        environment.variables = {
          QML2_IMPORT_PATH = lib.mkDefault "${pkgs.qt6.qtdeclarative}/lib/qt-6/qml";
        };
        home-manager.users.${username} = {
          home.packages = [ quickshellPkg ];
          programs.quickshell = {
            enable = true;
            package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
            systemd.enable = true;
            configs = {
              "shell.qml" = ./shell.qml;
            };
          };
        };
      };
    };
}
