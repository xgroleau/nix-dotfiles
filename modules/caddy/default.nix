{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.caddy;
in {

  options.modules.caddy = with types; {
    enable = mkEnableOption "Caddy server as an easy to use reverse proxy";
    email = mkReq types.str
      "Email to contact if there is an issue with the certificate";
    dataDir = mkReq types.str "Path to where the data will be stored";
  };

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      dataDir = cfg.dataDir;
      email = cfg.email;

    };

    systemd.tmpfiles.settings.caddy = {
      "${cfg.dataDir}" = {
        d = {
          mode = "0750";
          user = config.services.caddy.user;
          group = config.services.caddy.group;
        };
      };
    };

  };
}
