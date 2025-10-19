{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.cady = {
    console = {
      defaults = lib.mkEnableOption "The Cady approved defaults for a snazzy console time";
      shellAliases = lib.mkOption {
        description = "Shell Aliases for Bash";
        type = lib.types.attrs;
        default = {
          "n" = "nvim";
          ".." = "cd ..";
          "..." = "cd ../..";
          "rgf" = "rg --files | rg";
          "tree" =
            "rg --files | ${pkgs.tree}/bin/tree -CF --dirsfirst --fromfile | sed -e 's/└/╚/g' -e 's/│/║/g' -e 's/─/═/g' -e 's/├/╠/g'";
        };
      };
      starship = {
        enable = lib.mkEnableOption "Enable starship console line";
        direnv = lib.mkEnableOption "Include direnv when in an active flake in Starship";
      };
    };
  };
  config = lib.mkMerge [
    (lib.mkIf config.cady.console.defaults {

      home.packages = with pkgs; [ delta ];
      home.sessionVariables = {
        EDITOR = "";
        VISUAL = "nvim";
        # might switch to bat
        MANPAGER = "nvim +Man!";
        MANWIDTH = 999;
      };

      programs.bash = {
        enable = true;
        shellAliases = config.cady.console.shellAliases;
        bashrcExtra = ''
          if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
            exec tmux a
          fi
        '';
      };

      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };

      programs.kitty = {
        enable = true;
        settings = {
          background_opacity = lib.mkForce "0.8";
          background_blur = "1";
          dynamic_background_opacity = "yes";
          background_tint = "0";
          cursor_trail = "1";
        };
      };

      programs.git = {
        enable = true;
        lfs.enable = true;
        settings = {
          user.email = lib.mkDefault "evanev7@gmail.com";
          user.name = lib.mkDefault "Evan";
          push = {
            autoSetupRemote = true;
          };
          pull.rebase = true;
          rebase.autoStash = true;
          color.ui = "auto";
          init.defaultBranch = "main";
          commit.verbose = true;
          rerere.enabled = true;
          merge.conflictstyle = "zdiff3";
          diff.algorithm = "histogram";
          delta.navigate = true;
          "url \"git@github.com:\"".insteadOf = "https://github.com/";
          "url \"git@github.com:exo-explore/\"".insteadOf = "exo:";
          "url \"git@github.com:evanev7/\"".insteadOf = "ev:";
          core.compression = 9;
          core.whitespace = "error";
        };
      };

      programs.tmux = {
        enable = true;
        mouse = true;
        extraConfig = '''';
        baseIndex = 1;
        historyLimit = 100000;
        newSession = true;
        sensibleOnTop = true;
        plugins = with pkgs.tmuxPlugins; [
          vim-tmux-navigator
          better-mouse-mode
          sidebar
        ];
      };

      programs.delta = {
        enable = true;
        enableGitIntegration = true;
      };

      programs.lazygit = {
        enable = true;
        settings = {
          git.paging = {
            colorArg = "always";
            pager = "delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
          };
          gui.nerdFontsVersion = "3";
          keybinding.universal = {
            prevItem-alt = "l";
            nextItem-alt = "k";
            scrollLeft = "J";
            scrollRight = "'";
            prevBlock-alt = "j";
            nextBlock-alt = ";";
            scrollUpMain-alt1 = "L";
            scrollDownMain-alt1 = "K";
          };
          commits = {
            moveDownCommit = "<c-k>";
            moveUpCommit = "<c-l>";
            openLogMenu = "";
          };

        };
      };
    })
    (lib.mkIf (config.cady.console.defaults && config.cady.console.starship.enable) {
      programs.starship = {
        enable = true;
        settings = {
        }
        // (
          if config.cady.console.starship.direnv then
            {
              custom.direnv = {
                format = "[\\[direnv\\]]($style) ";
                style = "fg:yellow dimmed";
                when = "env | grep -E '^DIRENV_FILE='";
              };
            }
          else
            { }
        );
      };
    })
  ];
}
