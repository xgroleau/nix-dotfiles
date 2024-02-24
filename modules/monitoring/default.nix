{ config, lib, pkgs, ... }:
let
  cfg = config.modules.monitoring;
  hostname = config.networking.hostName;
in {

  options.modules.monitoring = with lib.types; {
    enable = lib.mkEnableOption "Monitoring module";

    prometheus_target = lib.mkOption {
      type = types.str;
      default =
        "127.0.0.1:${toString config.services.prometheus.exporters.node.port}";
      description = "Prometheus node to scrape";
    };

    smtp = lib.mkOption {
      type = types.submodule {
        options = {
          host = lib.mkOption {
            type = types.str;
            description = "Host to use with the port eg. smtp.gmail.com:587";
          };
          from = lib.mkOption {
            type = types.str;
            description = "Email to use to send";
          };
          username = lib.mkOption {
            type = types.str;
            description = "Username to authenticate";
          };
          passwordFile = lib.mkOption {
            type = types.str;
            description = "Path to the password file";
          };
          to = lib.mkOption {
            type = types.str;
            description = "Email to receive  alerts";
          };
        };
        description = "Email alerting configuration";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.grafana = {
      enable = true;

      settings = {
        server = rec {
          protocol = "http";
          http_port = 3010;
          http_addr = "0.0.0.0";
          domain = hostname;
        };
        analytics.reporting_enabled = false;
      };

      provision = {
        enable = true;
        datasources.settings.datasources = [
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

      rules = [
        (builtins.toJSON {
          groups = [{
            name = "nixos-monitoring";
            rules = [
              {
                alert = "NodeDown";
                expr = "up == 0";
                for = "5m";
                annotations = {
                  summary = "{{$labels.alias}}: Node is down.";
                  description =
                    "{{$labels.alias}} has been down for more than 5 minutes.";
                };
              }
              {
                alert = "Node90Full";
                expr = ''
                  sort(node_filesystem_free{device!="ramfs"} < node_filesystem_size{device!="ramfs"} * 0.1) / 1024^3'';
                for = "5m";
                annotations = {
                  summary =
                    "{{$labels.alias}}: Filesystem is running out of space soon.";
                  description =
                    "{{$labels.alias}} device {{$labels.device}} on {{$labels.mountpoint}} got less than 10% space left on its filesystem.";
                };
              }
              {
                alert = "Node90FullIn4H";
                expr = ''
                  predict_linear(node_filesystem_free{device!="ramfs"}[1h], 4*3600) <= 0'';
                for = "5m";
                annotations = {
                  summary =
                    "{{$labels.alias}}: Filesystem is running out of space in 4 hours.";
                  description =
                    "{{$labels.alias}} device {{$labels.device}} on {{$labels.mountpoint}} is running out of space of in approx. 4 hours";
                };
              }
              {
                alert = "NodeFiledescriptorsFull3h";
                expr =
                  "predict_linear(node_filefd_allocated[1h], 3*3600) >= node_filefd_maximum";
                for = "10m";
                annotations = {
                  summary =
                    "{{$labels.alias}} is running out of available file descriptors in 3 hours.";
                  description =
                    "{{$labels.alias}} is running out of available file descriptors in approx. 3 hours";
                };
              }
              {
                alert = "NodeLoad1At90percent";
                expr = ''
                  node_load1 / on(alias) count(node_cpu{mode="system"}) by (alias) >= 0.9'';
                for = "1h";
                annotations = {
                  summary = "{{$labels.alias}}: Running on high load.";
                  description =
                    "{{$labels.alias}} is running with > 90% total load for at least 1h.";
                };
              }
              {
                alert = "NodeCpuUtil90Percent";
                expr = ''
                  100 - (avg by (alias) (irate(node_cpu{mode="idle"}[5m])) * 100) >= 90'';
                for = "1h";
                annotations = {
                  summary = "{{$labels.alias}}: High CPU utilization.";
                  description =
                    "{{$labels.alias}} has total CPU utilization over 90% for at least 1h.";
                };
              }
              {
                alert = "NodeRamUsing90Percent";
                expr = ''
                  node_memory_MemFree + node_memory_Buffers + node_memory_Cached < node_memory_MemTotal * 0.1
                '';
                for = "30m";
                annotations = {
                  summary = "{{$labels.alias}}: Using lots of RAM.";
                  description =
                    "{{$labels.alias}} is using at least 90% of its RAM for at least 30 minutes now.";
                };
              }
              {
                alert = "NodeSwapUsing80Percent";
                expr = ''
                  node_memory_SwapTotal - (node_memory_SwapFree + node_memory_SwapCached) > node_memory_SwapTotal * 0.8
                '';
                for = "10m";
                annotations = {
                  summary = "{{$labels.alias}}: Running out of swap soon.";
                  description =
                    "{{$labels.alias}} is using 80% of its swap space for at least 10 minutes now.";
                };
              }

              {
                alert = "SystemDUnitDown";
                expr = ''node_systemd_unit_state{state="failed"} == 1'';
                for = "5m";
                annotations = {
                  summary =
                    "{{$labels.instance}} failed to (re)start the following service {{$labels.name}}.";
                };
              }
              {
                alert = "RootPartitionFull";
                for = "10m";
                expr = ''
                  (node_filesystem_free_bytes{mountpoint="/"} * 100) / node_filesystem_size_bytes{mountpoint="/"} < 10'';
                annotations = {
                  summary = ''
                    {{ $labels.job }} running out of space: {{ $value | printf "%.2f" }}% < 10%'';
                };
              }
            ];
          }];
        })

      ];
      # Send notifications to
      alertmanagers = [{
        scheme = "http";
        path_prefix = "/";
        static_configs = [{
          targets = [
            "127.0.0.1:${toString config.services.prometheus.alertmanager.port}"
          ];
        }];
      }];

      #Receive notifications
      alertmanager = {
        enable = true;
        port = 3024;
        environmentFile = config.age.secrets.authentikEnv.path;
        listenAddress = "127.0.0.1";
        configuration = {
          global = {
            smtp_smarthost = "mail.gmx.com:587";
            smtp_require_tls = true;
            smtp_from = "sheogorath@gmx.com";
            smtp_auth_username = "xavgroleau@gmx.com";
            smtp_auth_password = "$AUTHENTIK_EMAIL__PASSWORD";
          };
          route = {
            group_by = [ "alertname" "alias" ];
            group_wait = "10s";
            receiver = "admin-smtp";
          };
          receivers = [{
            name = "admin-smtp";
            email_configs = [{
              to = "xavgroleau@gmail.com";
              send_resolved = false;
            }];
          }];
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
        server = { http_listen_port = 3100; };

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
          configs = [{
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

        analytics = { reporting_enabled = false; };
      };
    };
  };
}
