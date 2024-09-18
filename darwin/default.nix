{
  config,
  pkgs,
  inputs,
  ...
}:

let
  overlays = import ../overlays { inherit inputs; };
in
{

  imports = [
    ./aerospace
    ./home
    ./homebrew
  ];

  config = {
    modules.darwin = {
      home = {
        enable = true;
        username = "xgroleau";
      };
      homebrew.enable = true;
      aerospace.enable = true;
    };

    nixpkgs = {
      config.allowUnfree = true;
      hostPlatform = "aarch64-darwin";
      overlays = [ overlays.unstable-packages ];
    };

    nix = {
      package = pkgs.nixVersions.latest;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';

      # Avoid always redownloading the registry
      registry.nixpkgsu.flake = inputs.nixpkgs; # For flake commands
      nixPath = [ "nixpkgsu=${inputs.nixpkgs}" ]; # For legacy commands
      settings.trusted-users = [ "@admin" ];
    };

    services = {
      nix-daemon.enable = true;
    };

    system = {
      startup.chime = false;

      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      activationScripts.postUserActivation.text = ''
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';

      defaults = {
        dock = {
          autohide = true;
          show-recents = false;
        };

        trackpad = {
          Clicking = true;
          TrackpadRightClick = true;
          TrackpadThreeFingerDrag = true;
        };

        NSGlobalDomain = {
          # UI settings
          AppleEnableSwipeNavigateWithScrolls = true;
          AppleInterfaceStyle = "Dark";
          AppleMetricUnits = 1;
          AppleShowAllExtensions = true;
          AppleTemperatureUnit = "Celsius";
          "com.apple.sound.beep.feedback" = 0;

          # Trackpad
          "com.apple.swipescrolldirection" = true;

          # Keyboard
          KeyRepeat = 2;
          InitialKeyRepeat = 15;
          AppleKeyboardUIMode = 3;
          ApplePressAndHoldEnabled = true;

          # Char Substitutaion
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
        };
      };

      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
      };
    };

    system.stateVersion = 5;
  };
}
