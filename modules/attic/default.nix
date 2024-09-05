{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.attic.server;
in

{
  options.modules.attic.server = {
    enable = lib.mkEnableOption "Monitoring module, will monitor another server, see config.modules.monitoring.target for the target system to monitor";

    port = lib.mkOption {
      type = lib.types.port;
      default = 14000;
      description = "The port to use";
    };

    dataDir = lib.mkoption {
      type = lib.types.str;
      description = "Path where the data and the sklite will be stored";

    };
    endpoint = lib.mkoption {
      type = lib.types.str;
      description = "Endpoint url, must end with a slash, e.g. https://your.domain.tld/";
    };

  };

  config = lib.mkIf cfg.enable {
    services.atticd = {

      enable = true;
      user = "atticd";
      group = "atticd";

      # Replace with absolute path to your credentials file

      settings = {
        listen = "[::]:${cfg.port}";

        credentialsFile = "/etc/atticd.env";
        database.url = "sqlite://${cfg.dataDir}/server.db?mode=rwc";
        api-endpoint = cfg.endpoint;
        require-proof-of-possession = false;
        default-retention-period = "1 months";

        chunking = {
          nar-size-threshold = 64 * 1024; # 64 KiB
          min-size = 16 * 1024; # 16 KiB
          avg-size = 64 * 1024; # 64 KiB
          max-size = 256 * 1024; # 256 KiB
        };

        storage = {
          type = "local";
          path = "${cfg.dataDir}/storage";
        };

        compression = {
          type = "zstd";
        };

      };
    };

    systemd.tmpfiles.settings.caddy = {
      "${cfg.dataDir}" = {
        d = {
          mode = "0750";
          user = "atticd";
          group = "atticd";
        };
      };

      "${cfg.dataDir}/storage" = {
        d = {
          mode = "0750";
          user = "atticd";
          group = "atticd";
        };
      };
    };
  };
}
