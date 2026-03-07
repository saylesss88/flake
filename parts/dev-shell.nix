{
  perSystem =
    { pkgs, system, ... }:
    {
      devshells.default = {
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

        motd = ''
          {2}── NixOS Dev Shell ──────────────────────────────────────────{reset}
          {9}  System: {reset} ${system}
          {2}──────────────────────────────────────────────────────────────{reset}
        '';

        commands = [
          {
            name = "rebuild";
            help = "Run nh os switch on the current flake";
            command = "nh os switch .";
            package = "nh";
          }
          {
            name = "fmt";
            help = "Format all nix files in the project";
            command = "nix fmt";
            package = "nixfmt";
          }
        ];
      };
    };
}
