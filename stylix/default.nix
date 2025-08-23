{ pkgs, ... }:
let
  mono-font = {
    package = pkgs.nerd-fonts.comic-shanns-mono;
    name = "ComicShannsMono Nerd Font";
  };
in
{
  # Enable Stylix
  stylix = {
    enable = true;
    image = ./bastien-grivet-dandd-spaceship.jpg;
    base16Scheme = ./chicago-valua.yaml;
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/monokai.yaml";
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/valua.yaml";
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/chicago-night.yaml";
    #base16Scheme = import ./eclipse-generated-2.nix;
    polarity = "dark";

    # Cursors
    cursor = {
      name = "Vimix-cursors";
      package = pkgs.vimix-cursors;
      #name = "BreezeX-RosePine-Linux";
      #package = pkgs.rose-pine-cursor;

      size = 32;
    };

    # Fonts
    fonts = {
      serif = mono-font;
      sansSerif = mono-font;
      monospace = mono-font;
      emoji = {
        package = pkgs.twitter-color-emoji;
        name = "Twitter Color Emoji";
      };
    };
  };
}
