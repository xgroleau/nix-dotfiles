{ config, lib, pkgs, ... }:

let

  cfg = config.modules.firefly-iii;
  containerBackendName = config.virtualisation.oci-containers.backend;
  containerBackend = pkgs."${containerBackendName}" + "/bin/"
    + containerBackendName;

in {

  options.modules.firefly-iii = with lib.types; {
    enable = lib.mkEnableOption
      "Enables immich, a self hosted google photo alternative";

    openFirewall = lib.mkEnableOption "Open the required ports in the firewall";

    port = lib.mkOption {
      type = types.port;
      default = 9300;
      description = "The port to use";
    };

    dataDir = lib.mkOption {
      type = types.str;
      description = "Path to where the data will be stored";
    };

    appKeyFile = lib.mkOption {
      type = types.str;
      description = "Path to where the app key is  stored";
    };

    appUrl = lib.mkOption {
      type = types.str;
      description = "URL of the firefly-iii instance";
    };
  };

  config = lib.mkIf cfg.enable {

    virtualisation.oci-containers.containers = {
      firefly-iii-core = {
        image = "fireflyiii/core:latest";
        environment = {
          APP_URL = cfg.appUrl;
          APP_KEY_FILE = cfg.appKeyFile;
          DB_CONNECTION = "sqlite";

          # MAIL_MAILER = mail.driver;
          # MAIL_HOST = mail.host;
          # MAIL_PORT = mail.port;
          # MAIL_FROM = mail.from;
          # MAIL_USERNAME = mail.user;
          # MAIL_PASSWORD._secret = mail.passwordFile;
          # MAIL_ENCRYPTION = mail.encryption;
        };
        volumes = [
          "${cfg.dataDir}:/var/www/html/storage:rw"
          "${cfg.appKeyFile}:${cfg.appKeyFile}:r"
        ];
        ports = [ "${toString cfg.port}:8080/tcp" ];
        extraOptions = [ "--network=firefly-iii-bridge" ];
      };

      # firefly-iii-cron = {
      #   image = "alpine";
      #   # TODO:  FIX
      #   cmd = [
      #     "sh"
      #     "-c"
      #     ''
      #       echo "0 3 * * * wget -qO- http://app:8080/api/v1/cron/REPLACEME" | crontab - && crond -f -L /dev/stdout''
      #   ];
      #   log-driver = "journald";
      #   extraOptions = [ "--network=firefly-iii-bridge" ];
      # };

    };
    networking.firewall = {
      allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
    };

    systemd = {
      # Network creation
      services.init-firefly-iii-network = {
        description = "Create the network bridge for firefly-iii.";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "oneshot";
        script = ''
          # Put a true at the end to prevent getting non-zero return code, which will
          # crash the whole service.
          check=$(${containerBackend} network ls | ${pkgs.gnugrep}/bin/grep "firefly-iii-bridge" || true)
          if [ -z "$check" ]; then
            ${containerBackend} network create firefly-iii-bridge
          else
               echo "firefly-iii-bridge already exists in docker"
           fi
        '';

      };

      # Folder
      tmpfiles.settings.firefly = {
        "${cfg.dataDir}" = {
          d = {
            mode = "0777";
            user = "root";
          };
        };

        "${cfg.dataDir}/database/database.sqlite" = {
          f = {
            mode = "0777";
            user = "root";
          };
        };
      };

    };
  };
}
