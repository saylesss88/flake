{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.marksman
    pkgs.markdown-oxide
    pkgs.markdownlint-cli
    pkgs.markdownlint-cli2
    pkgs.nodePackages.prettier
    pkgs.prettierd
    pkgs.shfmt
    pkgs.shellcheck
    pkgs.nixd
    pkgs.nodejs_22
    pkgs.nil
    pkgs.lua-language-server
    pkgs.bash-language-server
    pkgs.stylua
    pkgs.jq
    pkgs.taplo
    pkgs.deadnix
    pkgs.alejandra
    pkgs.nixfmt-rfc-style
  ];
}
