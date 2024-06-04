{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.monitoring.target;
  hostname = config.networking.hostName;
in
{

  options.modules.monitoring.target = with lib.types; {
    enable = lib.mkEnableOption "The target that will be monitored. Enables promtail and prometheus node exporter for systemd ";

    promtailPort = lib.mkOption {
      type = types.port;
      default = 13200;
      description = "Port for the promtail server";
    };

    prometheusPort = lib.mkOption {
      type = types.port;
      default = 13050;
      description = "Port for the prometheus exporter";
    };

    lokiAddress = lib.mkOption {
      type = types.str;
      default = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
      description = "Loki address, defaults to local instance";
    };
  };

  config = lib.mkIf cfg.enable {
    services.prometheus = {
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
          port = cfg.prometheusPort;
        };
      };
    };

    services.promtail = {
      enable = true;
      configuration = {
        server = {
          http_listen_port = cfg.promtailPort;
          grpc_listen_port = 0;
        };
        positions = {
          filename = "/tmp/positions.yaml";
        };
        clients = [ { url = cfg.lokiAddress; } ];
        scrape_configs = [
          {
            job_name = "journal";
            journal = {
              max_age = "12h";
              labels = {
                job = "systemd-journal";
                host = hostname;
              };
            };
            relabel_configs = [
              {
                source_labels = [ "__journal__systemd_unit" ];
                target_label = "unit";
              }
            ];
          }
        ];
      };
    };
  };
}
