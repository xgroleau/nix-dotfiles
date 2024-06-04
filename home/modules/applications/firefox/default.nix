{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.applications.firefox;
in
{

  options.modules.applications.firefox = {
    enable = lib.mkEnableOption "Enables firefox with some goodies and base config";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox.override {
        nativeMessagingHosts = [
          # Tridactyl native connector
          pkgs.tridactyl-native
        ];
      };
    };

    home.sessionVariables.BROWSER = "firefox";
    xdg.configFile.tridactyl.source = ./config;
  };
}
