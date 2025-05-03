# NixOS Flake

### Overview

**Commands**:

- `upd`: nushell alias for `nix-upgrade` updates and switches to new build

- `upd -i`: Interactive choose which programs to update with fzf. Use Tab to select multiple entries.

- `fr`: flake-rebuild, runs `nh os switch /home/${username}/my-nixos`

- `fu`: flake-update, `nh os switch --update /home/${username}/my-nixos`

- `nix build .#nixos`: build and deploy your configuration as a package, rather than by invoking `nixos-rebuild`. This will build an executable in
  `./result/bin/switch-to-configuration` You need to run `sudo ./result/bin/switch-to-configuration switch` to load the environment.

- `nix run .#deploy-nixos` build-and-deploy script

- `nix build .#nixos-vm`: build and deploy your configuration in a vm. Launch the vm executable with `sudo result/bin/run-magic-vm` (your hostname will go where `magic` is placed). The configuration for the vm is in `~/my-nixos/lib/vms/nixos-vm.nix`

- `nix repl .#repl`: Load flake into repl or `nixos-rebuild repl --flake .`

- `nix fmt`: When run in root of flake it will format the whole configuration

- `nix flake check`: Run style check with treefmt-nix, I recommend running `nix fmt` first.

- `nix flake show`: Show the flakes outputs, the VM and configuration as a package outputs cause this to fail. I believe it's because they output derivations at a level not compatable with `nix flake show`.

- I switched default shells to nushell, some commands act differently with nu compared to say zsh such as pipelines and `&&`. That being said I set up `just` and made a `justfile` to simplify some commands, just typing `just` will show you what's available.

- `just`: show available just commands

- `just fu`: flake update

- `just ncg`: garbage-collection

- `just cleanup`: Run `nh os clean`

Some custom nushell commands:

- `nix-upgrade -i`: interactive upgrade, choose which packages to upgrade

- `nix-upgrade /path/to/flake` upgrade all

- `nix-list-system` # list all installed packages

- `ns` Shorthand search (`nix search nixpkgs ...`): Usage `ns fzf`

- `nufetch`: List system details

- `(nufetch).kernel`: List kernel

- `Ctrl+t`: Carapace menu listing available commands

- `Ctrl+r`: Atuin Shell History

- `Ctrl+Space`: Top-level custom command menu

- `man <TAB>`: Search through available man pages with fzf

- `$env.<TAB>`: Search Nushell environment variables

- `performance`: Runs `sudo cpupower frequency-set -g performance`

- `powersave`: Runs `sudo cpupower frequency-set -g powersave`

- `gp`: Runs `git push origin main`

- `git ac -m "commit message"`: Runs git commit and git add in 1 command.

- **Defaults**:

- Editor | helix

- Browser | firefox

- Terminal | ghostty

- PDF | zathura

- Files | yazi

#### Outputs Explained

- Easy Builds and Deployment:

  - Can build system declaratively using `nix build .#nixos`.
  - `nix build .#nixos --dry-run`

  - The `deploy-nixos` app streamlines deployment making updates seamless.

    - Run it with `nix run .#deploy-nixos`

- VM Testing:

  - Running `nix build .#nixos-vm` gives you a virtualized environment where you can test settings before deploying them on your host.

  - To activate the `nixos-vm`, after the above command run: `result/bin/run-magic-vm`

- Debugging:

  - Integration with `treefmt-nix` for formatting checks (`checks.${system}.style`) for consistency in the whole configuration. Run `nix fmt` in the flake directory to format the whole config and `nix flake check` to run the custom checks.

  - The `repl` function gives us an interactive debugging environment, allowing you to inspect Flake definitions `self`.

  - `repl.nix` has a bunch of comments showing some commands you can try

Example:

```nix
nix repl .#repl
nix-repl> flake.inputs.nixpkgs.lib.version
"25.05.20250421.c11863f"
```

- In some situations you may be better off running `nixos-rebuild repl /path/to/flake`.

- Search through whole config for 'string':

```nu
rg 'initExtra' ~/flake
grep 'custom' ~/flake
```

- If you found this useful, please consider leaving a star!
