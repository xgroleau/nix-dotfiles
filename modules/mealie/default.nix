{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.mealie;
in

{
  options.modules.mealie = with lib.types; {
    enable = lib.mkEnableOption "OwnCloudInfiniteScale, Nextcloud but without bloat";

    port = lib.mkOption {
      type = types.port;
      default = 10400;
      description = "The port to use";
    };

    dataDir = lib.mkOption {
      type = types.str;
      description = "Path to where the data will be stored";
    };

    settings = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = { };
      description = ''
        Configuration of the Mealie service.

        See [the mealie documentation](https://nightly.mealie.io/documentation/getting-started/installation/backend-config/) for available options and default values.

        In addition to the official documentation, you can set {env}`MEALIE_LOG_FILE`.
      '';
      example = {
        ALLOW_SIGNUP = "false";
      };
    };

    credentialsFile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      example = "/run/secrets/mealie-credentials.env";
      description = ''
        File containing credentials used in mealie such as {env}`POSTGRES_PASSWORD`
        or sensitive LDAP options.

        Expects the format of an `EnvironmentFile=`, as described by {manpage}`systemd.exec(5)`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    virtualisation.oci-containers = {
      containers.mealie = {
        autoStart = true;
        image = "ghcr.io/mealie-recipes/mealie:v1.12.0@sha256:88e8e12542e9a2733c07f175682dc69e7360becb6137d604bb087a71ab33c5fe";
        ports = [ "${toString cfg.port}:9000" ];
        volumes = [ "${cfg.dataDir}:/app/data/" ];

        environmentFiles = [ cfg.credentialsFile ];
        environment = {
          ALLOW_SIGNUP = "false";
          MAX_WORKERS = "1";
          WEB_CONCURRENCY = "1";
        } // cfg.settings;

      };
    };

    # services = {
    #   mealie = {
    #     enable = true;
    #     port = cfg.port;
    #     credentialsFile = cfg.credentialsFile;
    #     # settings = {
    #     #   DATA_DIR = cfg.dataDir;
    #     # } // cfg.settings;
    #   };

    # };

    systemd.tmpfiles.settings.mealie = {
      "${cfg.dataDir}" = {
        d = {
          mode = "0755";
          user = "root";
        };
      };
    };
  };
}
