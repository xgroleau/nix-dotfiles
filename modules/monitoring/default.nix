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
        # dashboards = {
        #   settings = {
        #     providers = [{
        #       name = "My Dashboards";
        #       options.path = "/etc/grafana-dashboards";
        #     }];
        #   };
        # };

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

        notifiers = [ ];
      };
    };

    services.prometheus = {
      enable = true;
      port = 3020;

      rules = [''
        ALERT node_down
        IF up == 0
        FOR 5m
        LABELS {
          severity="page"
        }
        ANNOTATIONS {
          summary = "{{$labels.alias}}: Node is down.",
          description = "{{$labels.alias}} has been down for more than 5 minutes."
        }
        ALERT node_systemd_service_failed
        IF node_systemd_unit_state{state="failed"} == 1
        FOR 4m
        LABELS {
          severity="page"
        }
        ANNOTATIONS {
          summary = "{{$labels.alias}}: Service {{$labels.name}} failed to start.",
          description = "{{$labels.alias}} failed to (re)start service {{$labels.name}}."
        }
        ALERT node_filesystem_full_90percent
        IF sort(node_filesystem_free{device!="ramfs"} < node_filesystem_size{device!="ramfs"} * 0.1) / 1024^3
        FOR 5m
        LABELS {
          severity="page"
        }
        ANNOTATIONS {
          summary = "{{$labels.alias}}: Filesystem is running out of space soon.",
          description = "{{$labels.alias}} device {{$labels.device}} on {{$labels.mountpoint}} got less than 10% space left on its filesystem."
        }
        ALERT node_filesystem_full_in_4h
        IF predict_linear(node_filesystem_free{device!="ramfs"}[1h], 4*3600) <= 0
        FOR 5m
        LABELS {
          severity="page"
        }
        ANNOTATIONS {
          summary = "{{$labels.alias}}: Filesystem is running out of space in 4 hours.",
          description = "{{$labels.alias}} device {{$labels.device}} on {{$labels.mountpoint}} is running out of space of in approx. 4 hours"
        }
        ALERT node_filedescriptors_full_in_3h
        IF predict_linear(node_filefd_allocated[1h], 3*3600) >= node_filefd_maximum
        FOR 20m
        LABELS {
          severity="page"
        }
        ANNOTATIONS {
          summary = "{{$labels.alias}} is running out of available file descriptors in 3 hours.",
          description = "{{$labels.alias}} is running out of available file descriptors in approx. 3 hours"
        }
        ALERT node_load1_90percent
        IF node_load1 / on(alias) count(node_cpu{mode="system"}) by (alias) >= 0.9
        FOR 1h
        LABELS {
          severity="page"
        }
        ANNOTATIONS {
          summary = "{{$labels.alias}}: Running on high load.",
          description = "{{$labels.alias}} is running with > 90% total load for at least 1h."
        }
        ALERT node_cpu_util_90percent
        IF 100 - (avg by (alias) (irate(node_cpu{mode="idle"}[5m])) * 100) >= 90
        FOR 1h
        LABELS {
          severity="page"
        }
        ANNOTATIONS {
          summary = "{{$labels.alias}}: High CPU utilization.",
          description = "{{$labels.alias}} has total CPU utilization over 90% for at least 1h."
        }
        ALERT node_ram_using_90percent
        IF node_memory_MemFree + node_memory_Buffers + node_memory_Cached < node_memory_MemTotal * 0.1
        FOR 30m
        LABELS {
          severity="page"
        }
        ANNOTATIONS {
          summary="{{$labels.alias}}: Using lots of RAM.",
          description="{{$labels.alias}} is using at least 90% of its RAM for at least 30 minutes now.",
        }
        ALERT node_swap_using_80percent
        IF node_memory_SwapTotal - (node_memory_SwapFree + node_memory_SwapCached) > node_memory_SwapTotal * 0.8
        FOR 10m
        LABELS {
          severity="page"
        }
        ANNOTATIONS {
          summary="{{$labels.alias}}: Running out of swap soon.",
          description="{{$labels.alias}} is using 80% of its swap space for at least 10 minutes now."
        }
      ''];

      alertmanager = {
        enabled = true;
        port = 3024;
        listenAddress = "0.0.0.0";
        configuration = {
          global = {
            smtp_smarthost = "mail.gmx.com:587";
            smtp_require_tls = true;
            smtp_from = "sheogorath@gmx.com";
            smtp_auth_username = "xavgroleau@gmx.com";
            smtp_auth_password_file = config.age.secrets.gmxPass.path;
          };
          route = {
            group_by = [ "alertname" "alias" ];
            group_wait = "30s";
            group_interval = "2m";
            repeat_interval = "4h";
            receiver = "admin";
          };
          receivers = [{
            name = "admin";
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

      # MONITOREE
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
          port = 3021;
        };
      };

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

    services.promtail = {
      enable = true;
      configuration = {
        server = {
          http_listen_port = 28183;
          grpc_listen_port = 0;

        };
        positions = { filename = "/tmp/positions.yaml"; };
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
