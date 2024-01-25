{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let

  cfg = config.modules.immich;
  immichImage = "ghcr.io/imagegenius/immich:latest";
  immichVesion = "1.93.3-noml";
  immichHash =

    "sha256:440bfe850b36b6e41437f314af7441de3dd1874591c889b1adf3986ae86ff82b";

  postgresImage = "tensorchord/pgvecto-rs";
  postgresVersion = "pg14-v0.1.13";
  postgresHash =
    "sha256:c57994a048b449c2ed1cfc10dac82655aa2f207f10d41b51a47b3813a3b1f46b";
in {

  options.modules.immich = with types; {
    enable =
      mkEnableOption "Enables immich, a self hosted google photo alternative";

    openFirewall = mkBoolOpt' false "Open the required ports in the firewall";

    port = mkOpt' types.port 9300 "the port to use";

    configDir = mkReq types.str "Path to the config file";

    dataDir = mkReq types.str "Path to where the data will be stored";

    databaseDir = mkReq types.str "Path to where the database will be stored";

    envFile = mkReq types.str ''
      Path to where the secrets environment file is.
      Needs to contain the following environment values
        DB_PASSWORD="YYYY"
        POSTGRES_PASSWORD="YYYY"
    '';

  };

  config = mkIf cfg.enable {

    virtualisation.oci-containers.containers = {
      immich-server = {
        autoStart = true;
        image = "${immichImage}:${immichVersion}@${immichHash}";
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "${cfg.configDir}:/config"
          "${cfg.dataDir}:/photos"
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";

          # Redis
          DOCKER_MODS = "imagegenius/mods:universal-redis";
          REDIS_HOSTNAME = "localhost";

          DB_HOSTNAME = "immich-postgres";
          DB_USERNAME = "postgres";
          DB_PORT = 5432;
          DB_DATABASE_NAME = "immich";

          # Currently noml
          # MACHINE_LEARNING_WORKERS = "1";
          # MACHINE_LEARNING_WORKER_TIMEOUT = "120";
        };

        environmentFiles = [ cfg.envFile ];

        ports = [ "${toString cfg.port}:8080" ];
        dependsOn = [ "immich-postgres" ];
        extraOptions = [ "--network=immich" ];
      };

      immich-postgres = {
        autoStart = true;
        image = "${postgresImage}:${postgresVersion}@${postgresHash}";
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "${cfg.databaseDir}:/var/lib/postgresql/data"
        ];
        environment = {
          POSTGRES_USER = "postgres";
          POSTGRES_DB = "immich";
        };

        environmentFiles = [ cfg.envFile ];

        extraOptions = [ "--network=immich" ];
      };

    };

    networking.firewall =
      mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };

    systemd.tmpfiles.settings.immich = {
      "${cfg.configDir}" = {
        d = {
          mode = "0777";
          user = "root";
        };
      };
      "${cfg.dataDir}" = {
        d = {
          mode = "0777";
          user = "root";
        };
      };
      "${cfg.databaseDir}" = {
        d = {
          mode = "0777";
          user = "root";
        };
      };
    };
  };
}
