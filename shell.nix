{pkgs ? (import <nixpkgs>) {}, ...}: {
  default = pkgs.mkShell {
    NIX_CONFIG = "experimental-features = nix-command flakes pipe-operator";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git
      helix
      sops
      ssh-to-age
      gnupg
      age
    ];
  };
}
