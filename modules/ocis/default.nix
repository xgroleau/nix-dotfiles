{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let
  cfg = config.modules.ocis;
  ocisVersion = "4.0.5";
  ocisHash =
    "sha256:1bd0d3ff28b01c17964a1e71cbb410d5d82d630a7556297538723211ffce3513";
in {
  options.modules.ocis = with types; {
    enable =
      mkEnableOption "OwnCloudInfiniteScale, Nextcloud but without bloat";
    configDir = mkReq types.str "Path to the config file";
    dataDir = mkReq types.str "Path to where the data will be stored";
    port = mkOption {
      type = types.port;
      default = 9200;
      description = "the port to use";
    };
  };

  config = mkIf cfg.enable {

    virtualisation.oci-containers = {
      containers = {
        ocis = {
          autoStart = true;
          image = "owncloud/ocis:${ocisVersion}@${ocisHash}";
          ports = [ "${toString cfg.port}:9200" ];
          volumes =
            [ "${cfg.configDir}:/etc/ocis" "${cfg.dataDir}:/var/lib/ocis" ];
          environment = {
            DEMO_USERS = false;

            PROXY_TLS = false;
            PROXY_HTTP_ADDR = "0.0.0.0:9200";

            OCIS_INSECURE = true;
            OCIS_URL = "https://localhost:9200";
            OCIS_LOG_LEVEL = "info";
          };

          entrypoint = "/bin/sh";
          cmd = [ "-c" "ocis init | true; ocis server" ];
        };
      };
    };

    # Expose ports for container
    networking.firewall = { allowedTCPPorts = lib.mkForce [ cfg.port ]; };

    systemd.tmpfiles.settings.ocis = {
      "${cfg.dataDir}" = {
        d = {
          mode = "0777";
          user = "root";
        };
      };
      "${cfg.configDir}" = {
        d = {
          mode = "0777";
          user = "root";
        };
      };
    };
  };
}
