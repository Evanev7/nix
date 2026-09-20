{ stablePkgs, isHome, lib, ... }:
let
  mono-font = {
    package = stablePkgs.nerd-fonts.comic-shanns-mono;
    name = "ComicShannsMono Nerd Font";
  };
in
{
  # Enable Stylix
  stylix = {
    enable = true;
    image = ./bastien-grivet-dandd-spaceship.jpg;
    base16Scheme = ./chicago-valua.yaml;
    polarity = "dark";

    # Cursors
    cursor = {
      name = "Vimix-cursors";
      package = stablePkgs.vimix-cursors;
      size = 32;
    };

    # Fonts
    fonts = {
      serif = mono-font;
      sansSerif = mono-font;
      monospace = mono-font;
      emoji = {
        package = stablePkgs.twitter-color-emoji;
        name = "Twitter Color Emoji";
      };
    };
  } // lib.optionalAttrs isHome {
    targets = {
      firefox.enable = false;
      vscodium.enable = false;
    };
  };
} // lib.optionalAttrs isHome {
  home.pointerCursor.enable = true;
}
