{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.cady.console.useNvf = lib.mkEnableOption "some kinda neovim instance is around here";
  config = lib.mkIf config.cady.console.useNvf {
    systemd.user.services.lspmux = {
      Unit.Description = "lspmux server";
      Install.WantedBy = [ "default.target" ];
      Service = {
        ExecStart = "${pkgs.lspmux}/bin/lspmux server";
        Restart = "on-failure";
      };
    };
    xdg.configFile."lspmux/config.toml".text = ''pass_environment = ["PATH"]'';
    # Check here https://github.com/NotAShelf/nvf/blob/main/configuration.nix
    programs.nvf = {
      enable = true;
      enableManpages = true;
      settings.vim = {
        git.gitsigns.enable = true;
        lsp.enable = true;
        spellcheck.enable = true;
        visuals = {
          nvim-scrollbar.enable = true;
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          highlight-undo.enable = true;
        };
        statusline.lualine.enable = true;
        telescope.enable = true;
        languages = rec {
          enableTreesitter = true;
          enableFormat = true;
          enableExtraDiagnostics = true;

          rust = {
            enable = true;
            lsp.enable = false;
            extensions.crates-nvim.enable = true;
            extensions.rustaceanvim = {
              enable = true;
              setupOpts.server.cmd = [
                "${pkgs.lspmux}/bin/lspmux"
                "client"
                "--server-path"
                "${pkgs.rust-analyzer}/bin/rust-analyzer"
              ];
            };
          };
          nix.enable = true;
          clang = {
            enable = true;
            extraDiagnostics.enable = false;
          };
          python = {
            enable = true;
            extraDiagnostics.enable = false;
          };
          lua.enable = true;
          bash.enable = true;
          css.enable = true;
          go.enable = true;
          qml.enable = true;
          java.enable = true;
          zig.enable = true;
          typescript.enable = true;
          tsx = typescript;
          sql = {
            enable = true;
            extensions.sqls-nvim.enable = true;
          };
        };
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
      };
    };

  };
}
