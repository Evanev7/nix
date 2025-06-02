{ config, pkgs, lib, ... }:

# Thanks sleepy@discourse.nixos.org!
# Taken from https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265/5
{
  # Might eventually include extensions. Probably not though.
  options.cady = {
    firefox = { 
      enable = lib.mkEnableOption "Firefox defaults";
      userChromePath = lib.mkOption {
        type = lib.types.path;
        description = "Path to userChrome.css";
      };
      extraPrefs = lib.mkOption {
        description = "Additional options for Firefox preferences, loaded globally.";
        type = lib.types.attrs;
        default = {};
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.cady.firefox.enable) {
      
      # ---- sidebery is stored in firefox sync ----
      # My own code, no longer sleepy. 
      # https://discourse.nixos.org/t/anyone-using-firefox-gnome-theme-successfully-with-nixos-home-manager/19248 massively helped!!
      home.file.".mozilla/firefox/default/chrome/userChrome.css".source = config.cady.firefox.userChromePath;

      programs.firefox = {
        enable = true;
        package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
          extraPolicies = {
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
            DisablePocket = true;
            DisableFirefoxScreenshots = true;
            OverrideFirstRunPage = "";
            OverridePostUpdatePage = "";
            DontCheckDefaultBrowser = true;
            # add policies here...

            # ---- EXTENSIONS ----
            ExtensionSettings = {
              #  "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
              #  # uBlock Origin:
              #  "uBlock0@raymondhill.net" = {
              #    install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              #    installation_mode = "force_installed";
              #  };
              #  # add extensions here...
            };

            # ---- PREFERENCES ----
            # Set preferences shared by all profiles.
            Preferences = {
              "browser.contentblocking.category" = {
                Value = "strict";
              };
              "extensions.pocket.enabled" = false;
              "extensions.screenshots.disabled" = true;
              "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
              "browser.newtabpage.activity-stream.feeds.snippets" = false;
              "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
              "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
              "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
              "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
              "browser.newtabpage.activity-stream.showSponsored" = false;
              "browser.newtabpage.activity-stream.system.showSponsored" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
              # add global preferences here...
              "layout.css.color-mix.enabled" = true;
              "layout.css.light-dark.enabled" = true;
              "layout.css.has-selector.enabled" = true;
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              "browser.tabs.allow_transparent_browser" = true;
            } // config.cady.firefox.extraPrefs;
          };
        };

        # ---- PROFILES ----
        # Switch profiles via about:profiles page.
        # For options that are available in Home-Manager see
        # https://nix-community.github.io/home-manager/options.html#opt-programs.firefox.profiles
        profiles = {
          default = {
            # choose a profile name; directory is /home/<user>/.mozilla/firefox/profile_0
            id = 0; # 0 is the default profile; see also option "isDefault"
            name = "default"; # name as listed in about:profiles
            isDefault = true; # can be omitted; true if profile ID is 0
            settings = {
              # specify profile-specific preferences here; check about:config for options
            };
          };
        };
      };
    })
  ];
}
