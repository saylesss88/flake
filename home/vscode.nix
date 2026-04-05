{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.vscode.enable = lib.mkEnableOption "VSCode configuration";
  };

  config = lib.mkIf config.custom.vscode.enable {
    programs.vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        # dracula-theme.theme-dracula
        enkia.tokyo-night
        yzhang.markdown-all-in-one
        github.copilot
        github.copilot-chat
        rust-lang.rust-analyzer
        vadimcn.vscode-lldb
        tamasfe.even-better-toml
      ];
    };
  };
}
