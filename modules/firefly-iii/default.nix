{ config, lib, pkgs, ... }:

let

  cfg = config.modules.firefly-iii;
  containerBackendName = config.virtualisation.oci-containers.backend;
  containerBackend = pkgs."${containerBackendName}" + "/bin/"
    + containerBackendName;

  environment = {
    ALLOW_WEBHOOKS = "false";
    APP_DEBUG = "false";
    APP_ENV = "production";
    APP_KEY = "SomeRandomStringOf32CharsExactly"; # TODO:
    APP_LOG_LEVEL = "notice";
    APP_NAME = "FireflyIII";
    APP_URL = "http://localhost"; # TODO:
    AUDIT_LOG_LEVEL = "emergency";
    AUTHENTICATION_GUARD = "web";
    AUTHENTICATION_GUARD_EMAIL = "";
    AUTHENTICATION_GUARD_HEADER = "REMOTE_USER";
    BROADCAST_DRIVER = "log";
    CACHE_DRIVER = "file";
    CACHE_PREFIX = "firefly";
    COOKIE_DOMAIN = "";
    COOKIE_PATH = "/";
    COOKIE_SAMESITE = "lax";
    COOKIE_SECURE = "false";
    CUSTOM_LOGOUT_URL = "";
    DB_CONNECTION = "mysql";
    DB_DATABASE = "firefly";
    DB_HOST = "db";
    DB_PASSWORD = "secret_firefly_password";
    DB_PORT = "3306";
    DB_SOCKET = "";
    DB_USERNAME = "firefly";
    DEFAULT_LANGUAGE = "en_US";
    DEFAULT_LOCALE = "equal";
    DISABLE_CSP_HEADER = "false";
    DISABLE_FRAME_HEADER = "false";
    DKR_BUILD_LOCALE = "false";
    DKR_CHECK_SQLITE = "true";
    DKR_RUN_MIGRATION = "true";
    DKR_RUN_PASSPORT_INSTALL = "true";
    DKR_RUN_REPORT = "true";
    DKR_RUN_UPGRADE = "true";
    DKR_RUN_VERIFY = "true";
    ENABLE_EXCHANGE_RATES = "false";
    ENABLE_EXTERNAL_MAP = "false";
    ENABLE_EXTERNAL_RATES = "false";
    FIREFLY_III_LAYOUT = "v1";
    LOG_CHANNEL = "stack";
    MAIL_ENCRYPTION = "null";
    MAIL_FROM = "changeme@example.com";
    MAIL_HOST = "null";
    MAIL_MAILER = "log";
    MAIL_PASSWORD = "null";
    MAIL_PORT = "2525";
    MAIL_USERNAME = "null";
    MYSQL_SSL_CAPATH = "/etc/ssl/certs/";
    MYSQL_SSL_VERIFY_SERVER_CERT = "true";
    MYSQL_USE_SSL = "false";
    QUEUE_DRIVER = "sync";
    SEND_ERROR_MESSAGE = "true";
    SEND_REPORT_JOURNALS = "true";
    SESSION_DRIVER = "file";
    SITE_OWNER = "mail@example.com";
    STATIC_CRON_TOKEN = "";
    TZ = "America/Toronto";
    VALID_URL_PROTOCOLS = "";
  };
in {

  options.modules.firefly-iii = with lib.types; {
    enable = lib.mkEnableOption
      "Enables immich, a self hosted google photo alternative";
  };

  config = lib.mkIf cfg.enable {

    virtualisation.oci-containers.containers = {
      "firefly_iii_core" = {
        image = "fireflyiii/core:latest";
        environment = {
          ALLOW_WEBHOOKS = "false";
          APP_DEBUG = "false";
          APP_ENV = "production";
          APP_KEY = "SomeRandomStringOf32CharsExactly";
          APP_LOG_LEVEL = "notice";
          APP_NAME = "FireflyIII";
          APP_URL = "http://localhost";
          AUDIT_LOG_CHANNEL = "";
          AUDIT_LOG_LEVEL = "emergency";
          AUTHENTICATION_GUARD = "web";
          AUTHENTICATION_GUARD_EMAIL = "";
          AUTHENTICATION_GUARD_HEADER = "REMOTE_USER";
          BROADCAST_DRIVER = "log";
          CACHE_DRIVER = "file";
          CACHE_PREFIX = "firefly";
          COOKIE_DOMAIN = "";
          COOKIE_PATH = "/";
          COOKIE_SAMESITE = "lax";
          COOKIE_SECURE = "false";
          CUSTOM_LOGOUT_URL = "";
          DB_CONNECTION = "mysql";
          DB_DATABASE = "firefly";
          DB_HOST = "db";
          DB_PASSWORD = "secret_firefly_password";
          DB_PORT = "3306";
          DB_SOCKET = "";
          DB_USERNAME = "firefly";
          DEFAULT_LANGUAGE = "en_US";
          DEFAULT_LOCALE = "equal";
          DEMO_PASSWORD = "";
          DEMO_USERNAME = "";
          DISABLE_CSP_HEADER = "false";
          DISABLE_FRAME_HEADER = "false";
          DKR_BUILD_LOCALE = "false";
          DKR_CHECK_SQLITE = "true";
          DKR_RUN_MIGRATION = "true";
          DKR_RUN_PASSPORT_INSTALL = "true";
          DKR_RUN_REPORT = "true";
          DKR_RUN_UPGRADE = "true";
          DKR_RUN_VERIFY = "true";
          ENABLE_EXCHANGE_RATES = "false";
          ENABLE_EXTERNAL_MAP = "false";
          ENABLE_EXTERNAL_RATES = "false";
          FIREFLY_III_LAYOUT = "v1";
          IPINFO_TOKEN = "";
          LOG_CHANNEL = "stack";
          MAILGUN_DOMAIN = "";
          MAILGUN_ENDPOINT = "api.mailgun.net";
          MAILGUN_SECRET = "";
          MAIL_ENCRYPTION = "null";
          MAIL_FROM = "changeme@example.com";
          MAIL_HOST = "null";
          MAIL_MAILER = "log";
          MAIL_PASSWORD = "null";
          MAIL_PORT = "2525";
          MAIL_SENDMAIL_COMMAND = "";
          MAIL_USERNAME = "null";
          MANDRILL_SECRET = "";
          MAP_DEFAULT_LAT = "51.983333";
          MAP_DEFAULT_LONG = "5.916667";
          MAP_DEFAULT_ZOOM = "6";
          MYSQL_SSL_CAPATH = "/etc/ssl/certs/";
          MYSQL_SSL_VERIFY_SERVER_CERT = "true";
          MYSQL_USE_SSL = "false";
          PUSHER_ID = "";
          PUSHER_KEY = "";
          PUSHER_SECRET = "";
          QUEUE_DRIVER = "sync";
          SEND_ERROR_MESSAGE = "true";
          SEND_REPORT_JOURNALS = "true";
          SESSION_DRIVER = "file";
          SITE_OWNER = "mail@example.com";
          SPARKPOST_SECRET = "";
          STATIC_CRON_TOKEN = "";
          TRACKER_SITE_ID = "";
          TRACKER_URL = "";
          TRUSTED_PROXIES = "";
          TZ = "America/Toronto";
          VALID_URL_PROTOCOLS = "";
        };
        volumes = [ "firefly_iii_upload:/var/www/html/storage/upload:rw" ];
        ports = [ "80:8080/tcp" ];
        dependsOn = [ "firefly_iii_db" ];
        log-driver = "journald";
        extraOptions = [ "--network=firefly-iii-bridge" ];
      };

      firefly-iii-cron = {

        image = "alpine";
        # TODO:  FIX
        cmd = [
          "sh"
          "-c"
          ''
            echo "0 3 * * * wget -qO- http://app:8080/api/v1/cron/REPLACEME" | crontab - && crond -f -L /dev/stdout''
        ];
        log-driver = "journald";
        extraOptions = [ "--network=firefly-iii-bridge" ];
      };

      firefly-iii-db = {
        image = "mariadb:lts";
        environment = {
          MYSQL_DATABASE = "firefly";
          MYSQL_PASSWORD = "secret_firefly_password";
          MYSQL_RANDOM_ROOT_PASSWORD = "yes";
          MYSQL_USER = "firefly";
        };
        volumes = [ "firefly_iii_db:/var/lib/mysql:rw" ];
        log-driver = "journald";
        extraOptions = [ "--network=firefly-iii-bridge" ];
      };

    };
    networking.firewall = {
      allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
      interfaces."podman+".allowedUDPPorts = [ 53 ];
    };

    systemd = {
      # Backing up
      timers.firefly-iii-mysql-backup = {
        wantedBy = [ "timers.target" ];
        partOf = [ "firefly-iii-mysql-backup.service" ];
        timerConfig = {
          RandomizedDelaySec = "1h";
          OnCalendar = [ "*-*-* 02:00:00" ];
        };
      };

      services.firefly-iii-mysql-backup = {
        description = "Creates a backup for the firefly-iii database";
        wantedBy = [ "multi-user.target" ];
        path = with pkgs; [ containerBackend gzip ];

        script = ''
          ${containerBackend} exec -t firefly-iii-mysql pg_dumpall -c -U mysql | gzip > "${cfg.backupDir}/firefly-iii.sql.gz"
        '';

        serviceConfig = {
          User = "root";
          Type = "oneshot";
        };

      };

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
    };
  };
}
