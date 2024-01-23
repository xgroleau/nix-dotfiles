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
    reversePoxies = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = literalExpression ''
        {
          "some.example.com"="192.168.1.100:8080";
        };
      '';
      description = lib.mdDoc ''
        Declarative specification of reverse proxies hosted by Caddy.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      dataDir = cfg.dataDir;
      email = cfg.email;
      virtualHosts = lib.mapAttrs (addr: target) {
        serverAliases = [ "www.${addr}" ];
        extraConfig = ''
          reverse_proxy ${target}
        '';

      };

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
