{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.applications.discord;
in
{

  options.modules.applications.discord = {
    enable = lib.mkEnableOption "Enables discord and ignores the auto update check";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ discord ];
    xdg.configFile.discord = {
      source = ./config;
      recursive = true;
    };
  };
}
