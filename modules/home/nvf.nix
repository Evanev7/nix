{
  config,
  lib,
  ...
}:
{
  options.cady.console.useNvf = lib.mkEnableOption "some kinda neovim instance is around here";
  config = lib.mkIf config.cady.console.useNvf {
    # Check here https://github.com/NotAShelf/nvf/blob/main/configuration.nix
    programs.nvf = {
      enable = true;
      settings.vim = {
        keymaps = [
          # remap hjkl to jkl;
          {
            key = "j";
            action = "h";
            mode = [
              "n"
              "v"
            ];
          }
          {
            key = "k";
            action = "j";
            mode = [
              "n"
              "v"
            ];
          }
          {
            key = "l";
            action = "k";
            mode = [
              "n"
              "v"
            ];
          }
          {
            key = ";";
            action = "l";
            mode = [
              "n"
              "v"
            ];
          }

          {
            key = "<C-w>j";
            action = "<C-w>h";
            mode = "n";
          }
          {
            key = "<C-w>k";
            action = "<C-w>j";
            mode = "n";
          }
          {
            key = "<C-w>l";
            action = "<C-w>k";
            mode = "n";
          }
          {
            key = "<C-w>;";
            action = "<C-w>l";
            mode = "n";
          }

          {
            key = "h";
            action = ";";
            mode = [
              "n"
              "v"
            ];
          }
        ];
        lsp = {
          enable = true;
        };
        spellcheck.enable = true;
        visuals = {
          nvim-scrollbar.enable = true;
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          highlight-undo.enable = true;
        };
        statusline.lualine.enable = true;
        telescope.enable = true;
        languages = {
          enableTreesitter = true;
          enableFormat = true;
          enableExtraDiagnostics = true;

          rust = {
            enable = true;
            crates.enable = true;
          };
          nix.enable = true;
          clang.enable = true;
          python.enable = true;
          zig.enable = true;
          markdown.enable = true;
          lua.enable = true;
          bash.enable = true;
          css.enable = true;
        };
      };
    };

  };
}
