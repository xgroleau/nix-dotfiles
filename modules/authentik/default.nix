{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.authentik;
in {

  imports = [ ];

  options.modules.authentik = {
    enable = mkEnableOption "Enables the authentik module";
    envFile = mkReq' types.str "Path to the environment filek";

  };

  config = mkIf cfg.enable {
    containers.authentik = {
      autoStart = true;
      config = {
        services.authentik = {
          enable = true;
          createDatabase = true;
          environmentFile = cfg.envFile;
          settings = {
            disable_startup_analytics = true;
            avatars = "initials";
          };
        };

      };
    };
  };
}
