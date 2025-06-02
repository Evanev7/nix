{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-down = [ "disabled" ];
        switch-to-workspace-up = [ "disabled" ];
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          "blur-my-shell@aunetx"
          "pop-shell@system76.com"
        ];
      };
    };
  };
}
