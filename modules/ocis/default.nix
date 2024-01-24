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
    url = mkReq types.str
      "URL of the OCIS instance, needs to be https and the same as the OpenIDConnect proxy";
    port = mkOpt' types.port 9200 "the port to use";
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
            DEMO_USERS = "false";

            PROXY_TLS = "false";
            PROXY_HTTP_ADDR = "0.0.0.0:9200";

            OCIS_INSECURE = "false";
            OCIS_URL = cfg.url;
            OCIS_LOG_LEVEL = "info";
          };

          entrypoint = "/bin/sh";
          cmd = [ "-c" "ocis init | true; ocis server" ];
        };
      };
    };

    # Expose ports for container
    networking.firewall = { allowedTCPPorts = [ cfg.port ]; };

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
