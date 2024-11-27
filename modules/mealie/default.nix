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
    enable = lib.mkEnableOption "Mealie, a meal planner and grocery shopping list manager";

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
        image = "ghcr.io/mealie-recipes/mealie:v2.3.0@sha256:562ba8b1c98fbfa98a019ab6e0e45c88dae9a2e9a858ec4eac8f6321e46e9227";
        ports = [ "${toString cfg.port}:9000" ];
        volumes = [ "${cfg.dataDir}:/app/data/" ];
        user = "911:911";

        environmentFiles = [ cfg.credentialsFile ];
        environment = {
          ALLOW_SIGNUP = "false";
          MAX_WORKERS = "1";
          WEB_CONCURRENCY = "1";
        } // cfg.settings;

      };
    };

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
