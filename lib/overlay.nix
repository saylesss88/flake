_final: prev: let
  # Helper function to import a package
  callPackage = prev.lib.callPackageWith (prev // packages);

  # --- Codeium Specifics ---
  # Fetch the versions.json content. This path should be relative to where your
  # main flake.nix is, or you could make the codeium-flake an input to *this*
  # overlay if you really want to keep its structure separate.
  # For simplicity and direct use with your setup, let's reference it from your main flake.
  # This assumes your main flake.nix has 'codeium-flake.url = "path:./home/nixVim/codeiumFlake";'
  # and that the versions.json is inside that structure.
  codeiumVersions = prev.lib.importJSON "${prev.inputs.self}/home/nixVim/codeiumFlake/lua/codeium/versions.json";

  # Codeium LSP derivation
  codeium-lsp = prev.stdenv.mkDerivation {
    pname = "codeium-lsp";
    version = "v${codeiumVersions.version}";
    src = prev.fetchurl {
      url = "https://github.com/Exafunction/codeium/releases/download/language-server-v${codeiumVersions.version}/language_server_${prev.system}";
      sha256 = codeiumVersions.hashes.${prev.system};
    };
    sourceRoot = ".";
    phases = ["installPhase" "fixupPhase"];
    nativeBuildInputs =
      [prev.stdenv.cc.cc]
      ++ (
        if !prev.stdenv.isDarwin
        then [prev.autoPatchelfHook]
        else []
      );
    installPhase = ''
      mkdir -p $out/bin
      install -m755 $src $out/bin/codeium-lsp
    '';
  };

  # Codeium Neovim plugin derivation
  # Fetch the actual codeium-nvim plugin source.
  codeiumNvimPluginSrc = prev.fetchFromGitHub {
    owner = "Exafunction";
    repo = "codeium.nvim";
    # Use a specific commit hash for stability. Check their GitHub repo for latest stable.
    rev = "3196f7e4f9b87208947f6d4d03612d1c68677c7f"; # Example commit, use a real one!
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Calculate this with nix-prefetch-url
  };

  codeium-nvim = prev.vimUtils.buildVimPlugin {
    pname = "codeium";
    version = "v${codeiumVersions.version}-main"; # Adjust version based on plugin's actual versioning
    src = codeiumNvimPluginSrc; # Use the fetched source

    buildPhase = ''
      # This part injects the LSP path into the plugin's configuration
      mkdir -p lua/codeium
      cat << EOF > lua/codeium/installation_defaults.lua
      return {
        tools = {
          language_server = "${codeium-lsp}/bin/codeium-lsp"
        };
      };
      EOF
    '';
  };
  # --- End Codeium Specifics ---

  # Define all packages
  packages = {
    # Additional packages
    pokego = callPackage ./pac_defs/pokego.nix {};
    pokemon-colorscripts = callPackage ./pac_defs/pokemon-colorscripts.nix {};
    python-pyamdgpuinfo = callPackage ./pac_defs/python-pyamdgpuinfo.nix {};
    Tela-circle-dracula = callPackage ./pac_defs/Tela-circle-dracula.nix {};
    Bibata-Modern-Ice = callPackage ./pac_defs/Bibata-Modern-Ice.nix {};

    # Add Codeium packages here
    inherit codeium-lsp codeium-nvim;
  };
in
  packages
