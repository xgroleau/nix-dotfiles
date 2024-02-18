{ config, lib, pkgs, ... }:
let
  cfg = config.modules.monitoring;
  hostname = config.networking.hostName;
in {

  options.modules.monitoring = with lib.types; {
    enable = lib.mkEnableOption "Monitoring module";
  };

  config = lib.mkIf cfg.enable {
    # MONITORING
    services.grafana = rec {
      enable = true;
      port = 3010;

      addr = "127.0.0.1";
      rootUrl = "http://${hostname}:${port}";
      protocol = "http";
      analytics.reporting.enable = false;

      provision = {
        enable = true;
        datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url =
              "http://127.0.0.1:${toString config.services.prometheus.port}";
          }
          {
            name = "Loki";
            type = "loki";
            access = "proxy";
            url = "http://127.0.0.1:${
                toString
                config.services.loki.configuration.server.http_listen_port
              }";
          }
        ];
      };
    };

    services.prometheus = {
      enable = true;
      port = 3020;

      # MONITOREE
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
          port = 3021;
        };
      };
      scrapeConfigs = [{
        job_name = "nodes";
        static_configs = [{
          targets = [
            "127.0.0.1:${
              toString config.services.prometheus.exporters.node.port
            }"
          ];
        }];
      }];
    };

    services.loki = {
      enable = true;
      configuration = {
        auth_enabled = false;
        server = {
          http_listen_port = 3100;
          grpc_listen_port = 9096;
        };

        common = {
          instance_addr = "127.0.0.1";
          path_prefix = "/tmp/loki";
          storage = {
            filesystem = {
              chunks_directory = "/tmp/loki/chunks";
              rules_directory = "/tmp/loki/rules";
            };
          };
          replication_factor = 1;
          ring = { kvstore.store = "inmemory"; };
        };

        query_range = {
          results_cache = {
            cache = {
              embedded_cache = {
                enabled = true;
                max_size_mb = 100;
              };
            };
          };
        };

        schema_config = {
          config = [{
            from = "2020-10-24";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v12";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }];
        };

        limits_config = {
          reject_old_samples = true;
          reject_old_samples_max_age = "168h";
        };

        chunk_store_config = { max_look_back_period = "0s"; };

        table_manager = {
          retention_deletes_enabled = false;
          retention_period = "0s";
        };

        compactor = {
          working_directory = "/var/lib/loki";
          shared_store = "filesystem";
          compactor_ring = { kvstore = { store = "inmemory"; }; };
        };

        reporting_enabled = false;
      };
    };

    services.promtail = {
      enable = true;
      config = {
        server = {
          http_listen_port = 28183;
          grpc_listen_port = 0;

        };
        positions = { filename = /tmp/positions.yaml; };
        clients = [{
          url = "http://127.0.0.1:${
              toString
              config.services.loki.configuration.server.http_listen_port
            }/loki/api/v1/push";
        }];
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
