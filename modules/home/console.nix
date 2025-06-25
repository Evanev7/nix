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
      programs.bash = {
        enable = true;
        shellAliases = config.cady.console.shellAliases;
        bashrcExtra = ''
          if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
            exec tmux
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

      programs.tmux = {
        enable = true;
        mouse = true;
        plugins = with pkgs.tmuxPlugins; [
          sensible
          vim-tmux-navigator
          better-mouse-mode
          sidebar
        ];
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
        '';
      };
    })
    (lib.mkIf (config.cady.console.defaults && config.cady.console.starship.enable) {
      programs.starship = {
        enable = true;
        settings =
          {
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
