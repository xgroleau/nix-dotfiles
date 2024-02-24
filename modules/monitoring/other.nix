{ config, lib, pkgs, ... }:
let
  cfg = config.modules.monitoring;
  hostname = config.networking.hostName;
in {

  options.modules.monitoring = with lib.types; {
    enable = lib.mkEnableOption "Monitoring module";

    loki_address = lib.mkOption {
      type = types.str;
      default = "http://127.0.0.1:${
          toString config.services.loki.configuration.server.http_listen_port
        }/loki/api/v1/push";
      description = "Loki address, defaults to local instance";
    };
  };

  config = lib.mkIf cfg.enable {
    services.prometheus = {
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
          port = 3021;
        };
      };
    };

    services.promtail = {
      enable = true;
      configuration = {
        server = {
          http_listen_port = 28183;
          grpc_listen_port = 0;

        };
        positions = { filename = "/tmp/positions.yaml"; };
        clients = [{ url = cfg.loki_address; }];
        scrape_configs = [{
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = hostname;
            };
          };
          relabel_configs = [{
            source_labels = [ "__journal__systemd_unit" ];
            target_label = "unit";
          }];

        }];
      };

    };
  };

}
