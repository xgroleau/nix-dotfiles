{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.darwin.homebrew;
in
{

  options.modules.darwin.homebrew = with lib.types; {
    enable = lib.mkEnableOption "Enables the homebrew apps";
  };

  config = lib.mkIf cfg.enable {

    modules.darwin.home.extraHomeModules = [
      {
        programs.zsh = {
          initExtra = ''
            eval "$(/opt/homebrew/bin/brew shellenv)"
          '';
        };
      }
    ];

    homebrew = {
      enable = true;

      onActivation = {
        autoUpdate = false;
        cleanup = "zap";
      };

      # Applications to install from Mac App Store using mas.
      # You need to install all these Apps manually first so that your apple account have records for them.
      # otherwise Apple Store will refuse to install them.
      # For details, see https://github.com/mas-cli/mas
      masApps = { };

      taps = [
        "homebrew/services"
        "FelixKratz/formulae"
      ];

      brews = [
        "curl" # no not install curl via nixpkgs, it's not working well on macOS!
      ];

      casks = [
        "firefox"
        "google-chrome"
        "visual-studio-code"
        "spotify"

        # IM & audio & remote desktop & meeting
        "discord"
        "element"
        "mattermost"
        "slack"

        # Development
        "insomnia" # REST client
      ];
    };
  };
}
