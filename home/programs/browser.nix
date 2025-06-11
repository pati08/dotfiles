{ config, lib, pkgs, ... }:
let
  buildFirefoxXpiAddon = lib.makeOverridable ({ stdenv ? pkgs.stdenv
    , fetchurl ? pkgs.fetchurl, pname, version, addonId, url, sha256, meta, ...
    }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = fetchurl { inherit url sha256; };

      preferLocalBuild = true;
      allowSubstitutes = true;

      passthru = { inherit addonId; };

      buildCommand = ''
          dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
          mkdir -p "$dst"
          install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    });
  ffDesmodder = buildFirefoxXpiAddon {
    pname = "desmodder-for-desmos";
    version = "0.14.8";
    addonId = "DesModder@jared-hughes.github.io";
    url = "https://addons.mozilla.org/firefox/downloads/file/4492122/desmodder_for_desmos-0.14.8.xpi";
    sha256 = "sha256-bXoiqqE0FSzbXP2YfHqfcBHJntCB6J9kTiQ9YQrtZXQ=";
    meta = with lib; {
      homepage = "https://github.com/DesModder/DesModder";
      description = "Supercharge your Desmos graph creation and sharing experience with many convenient features";
      license = licenses.mit;
      mozPermissions = [
        "https://desmos.com/*"
        "https://wakatime.com"
      ];
      platforms = platforms.all;
    };
  };
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
  ffExtensionPackages = with pkgs.nur.repos.rycee.firefox-addons; [
    ublock-origin
    lastpass-password-manager
    better-canvas
    catppuccin-mocha-mauve
    tridactyl
    docsafterdark
    don-t-fuck-with-paste
    ffDesmodder
    tampermonkey
  ];
  ffExtensionSettings = builtins.listToAttrs (map (extPkg: { name = extPkg.addonId; value.settings = {
    installation_mode = "force_installed";
  }; }) ffExtensionPackages);
  ffExtensions = {
    packages = ffExtensionPackages;
    settings = ffExtensionSettings; 
    force = true;
  };
  ffPrefs = {
    # disable some first-run stuff
    "browser.disableResetPrompt" = true;
    "browser.download.panel.shown" = true;
    "browser.feeds.showFirstRunUI" = false;
    "browser.messaging-system.whatsNewPanel.enabled" = false;
    "browser.rights.3.shown" = true;
    "browser.shell.checkDefaultBrowser" = false;
    "browser.shell.defaultBrowserCheckCount" = 1;
    "browser.startup.homepage_override.mstone" = "ignore";
    "browser.uitour.enabled" = false;
    "startup.homepage_override_url" = "";
    "trailhead.firstrun.didSeeAboutWelcome" = true;
    "browser.bookmarks.restore_default_bookmarks" = false;
    "browser.bookmarks.addedImportButton" = true;

    # no password manager or autofill
    "signon.rememberSignons" = false;
    "signon.prefillForms" = false;
    # Set theme
    # "extensions.activeThemeID" = "{d090b7ee-a385-4d54-b9a4-f7164d17756d}";

    # auto enable extensions
    "extensions.autoDisableScopes" = 0;

    "browser.contentblocking.category" = "strict";
    "extensions.pocket.enabled" = false;
    "extensions.screenshots.disabled" = true;
    "browser.topsites.contile.enabled" = false;
    "browser.formfill.enable" = false;
    "browser.search.suggest.enabled" = false;
    "browser.search.suggest.enabled.private" = false;
    "browser.urlbar.suggest.searches" = false;
    "browser.urlbar.showSearchSuggestionsFirst" = false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    "browser.newtabpage.activity-stream.feeds.snippets" = false;
    "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
    "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
    "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
    "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.system.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "identity.fxaccounts.enabled" = false;

    # conf stuff
    browser.download.useDownloadDir = true;
  };
in
  {
  programs = {
    firefox = {
      enable = true;
      languagePacks = [ "fr" "en-US" ];

      /* ---- POLICIES ---- */
      # Check about:policies#documentation for options.
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "newtab"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        SearchBar = "unified"; # alternative: "separate"

        ExtensionSettings = {
          "*.installation_mode" = "blocked";
        };
      };
      profiles = {
        personal-profile = {
          id = 0;
          name = "Personal";
          isDefault = true;
          path = "default-profile";
          extensions = ffExtensions;
          settings = ffPrefs;
        };
        school-profile = {
          id = 1;
          name = "School";
          isDefault = false;
          path = "school-profile";
          extensions = ffExtensions;
          settings = ffPrefs;
        };
      };
    };
  };
}
# { config, pkgs, inputs, lib, ...}: let
#   buildFirefoxXpiAddon = lib.makeOverridable ({ stdenv ? pkgs.stdenv
#     , fetchurl ? pkgs.fetchurl, pname, version, addonId, url, sha256, meta, ...
#     }:
#     stdenv.mkDerivation {
#       name = "${pname}-${version}";
#
#       inherit meta;
#
#       src = fetchurl { inherit url sha256; };
#
#       preferLocalBuild = true;
#       allowSubstitutes = true;
#
#       passthru = { inherit addonId; };
#
#       buildCommand = ''
#         dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
#         mkdir -p "$dst"
#         install -v -m644 "$src" "$dst/${addonId}.xpi"
#       '';
#     });
#   ffDesmodder = buildFirefoxXpiAddon {
#     pname = "desmodder-for-desmos";
#     version = "0.14.8";
#     addonId = "DesModder@jared-hughes.github.io";
#     url = "https://addons.mozilla.org/firefox/downloads/file/4492122/desmodder_for_desmos-0.14.8.xpi";
#     sha256 = "sha256-bXoiqqE0FSzbXP2YfHqfcBHJntCB6J9kTiQ9YQrtZXQ=";
#     meta = with lib; {
#       homepage = "https://github.com/DesModder/DesModder";
#       description = "Supercharge your Desmos graph creation and sharing experience with many convenient features";
#       license = licenses.mit;
#       mozPermissions = [
#         "https://desmos.com/*"
#         "https://wakatime.com"
#       ];
#       platforms = platforms.all;
#     };
#   };
#   ffExtensions = with pkgs.nur.repos.rycee.firefox-addons; [
#     ublock-origin
#     lastpass-password-manager
#     better-canvas
#     catppuccin-mocha-mauve
#     tridactyl
#     docsafterdark
#     don-t-fuck-with-paste
#     ffDesmodder
#     tampermonkey
#   ];
# in {
#   programs.firefox = {
#     enable = true;
#     profiles = {
#       personal-profile = {
#         id = 0;
#         name = "Personal";
#         isDefault = true;
#         path = "/home/patrick/.mozilla/firefox/guyyj52m.default";
#         extensions.packages = ffExtensions;
#       };
#       school-profile = {
#         id = 1;
#         name = "School";
#         isDefault = false;
#         path = "/home/patrick/.mozilla/firefox/bgesmz8x.School";
#         extensions.packages = ffExtensions;
#       };
#     };
#   };
#
#   programs.chromium = {
#     enable = true;
#     extensions = [
#       { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
#       { id = "hdokiejnpimakedhajhdlcegeplioahd"; } # lastpass
#       { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
#       { id = "bkdgflcldnnnapblkhphbgpggdiikppg"; } # duckduckgo privacy
#     ];
#   };
# }
