# nixVim/plugins/codeium.nix (or wherever your main nixvim config module is)
{pkgs, ...}: {
  programs.nixvim = {
    # Enable and configure necessary base plugins for LSP/completion
    plugins = {
      windsurf-nvim = {
        enable = false;
        # package = inputs.codeium-flake.packages.${pkgs.system}.default;
      };
      # Codeium depends on plenary.nvim for some utilities
      # plenary.enable = true;
      # If you use nvim-cmp for completion, enable it here
      cmp.enable = true;
      # You might also need lspkind, luasnip, etc., depending on your full setup
    };

    # Add codeium-nvim as an extra plugin
    # It will be found because it's in your `./lib/overlay.nix` and that overlay is applied.
    extraPlugins = with pkgs.vimPlugins; [
      windsurf-nvim
    ];

    # This is crucial for Codeium to activate in Neovim
    # The `buildPhase` in your overlay already ensures `installation_defaults.lua`
    # points to the correct LSP path, so `setup()` is all that's needed here.
    extraConfigLua = ''
      require("codeium").setup()
      -- You can add more Codeium configuration here if needed,
      -- e.g., require("codeium").setup({ completion = { ... } })
    '';

    keymaps = [
      {
        mode = "n";
        key = "<leader>ac";
        action = "<cmd>Codeium Chat<CR>";
        options = {desc = "Codeium Chat";};
      }
      {
        mode = "i";
        key = "<C-;>";
        action.__raw = ''
          function()
            return vim.fn["codeium#Accept"]()
          end
        '';
        options.remap = true;
      }
    ];

    # Optional: If you want the LSP server globally available in your shell
    # environment.systemPackages = builtins.attrValues {
    #   inherit (pkgs)
    #     codeium-lsp;
    # };
  };
}
