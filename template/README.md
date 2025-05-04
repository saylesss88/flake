A NixOS virtual machine is created with the `nix-build` command:

```bash
nix-build '<nixpkgs/nixos>' -A vm -I nixpkgs=channel:nixos-25.05 -I nixos-config=./configuration.nix
```

- This command builds the attribute `vm` from the `nixos-25.05` release of NixOS, using the configuration as specified in the relative path.
