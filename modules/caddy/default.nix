{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.caddy;
in
{

  options.modules.caddy = with lib.types; {
    enable = lib.mkEnableOption "Caddy server as an easy to use reverse proxy";

    openFirewall = lib.mkEnableOption "Open the required ports in the firewall";

    email = lib.mkOption {
      type = types.str;
      description = "Email to contact if there is an issue with the certificate";
    };

    dataDir = lib.mkOption {
      type = types.str;
      description = "Path to where the data will be stored";
    };

    reverseProxies = lib.mkOption {
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

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      dataDir = cfg.dataDir;
      email = cfg.email;

      # See https://github.com/opencloud-eu/opencloud/issues/455
      virtualHosts = lib.mapAttrs (addr: target: {
        serverAliases = [ "www.${addr}" ];
        extraConfig = ''
          header {
              Access-Control-Allow-Origin "*"
              Access-Control-Allow-Methods "GET, POST, OPTIONS, PUT, DELETE"
              Access-Control-Allow-Headers "Content-Type, Authorization"
              Access-Control-Allow-Credentials "true"
              Access-Control-Max-Age "86400"
          }
          reverse_proxy ${target} {
              header_down -Content-Security-Policy
          }
        '';
      }) cfg.reverseProxies;
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [
        80
        443
      ];
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
