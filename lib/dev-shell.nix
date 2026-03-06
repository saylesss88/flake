{
  perSystem =
    { pkgs, system, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "nixos-dev";

        packages = with pkgs; [
          nixfmt
          deadnix
          nixd
          nil
          nh
          nix-diff
          nix-tree
          helix
          git
          ripgrep
          jq
          tree
        ];

        shellHook = ''
          echo "── NixOS Dev Shell ──────────────────────────────────────────"
          echo "  System: ${system}"
          echo "──────────────────────────────────────────────────────────────"
        '';
      };
    };
}
