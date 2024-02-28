{ config, pkgs, ... }:

let
  domain = "xgroleau.com";
  backupFolders = [
    "/vault"
    "/documents"
    "/data/backups"
    "/var/lib/jellyfin"
    "/var/lib/jellyseerr"
  ];
in {
  imports = [ ../base-config.nix ./disko.nix ./hardware-configuration.nix ];

  config = {
    # Custom modules
    modules = {
      home.username = "xgroleau";
      home.profile = "minimal";
      ssh.enable = true;
      secrets.enable = true;

      monitoring = {
        # TODO: Move the monitoring server to another system
        server = {
          enable = true;
          alerting = {
            enable = true;
            envFile = config.age.secrets.alertmanagerEnv.path;
            emailTo = "xavgroleau@gmail.com";
          };
        };
        target = { enable = true; };
      };

      authentik = {
        enable = true;
        port = 9000;
        metricsPort = 9300;
        dataDir = "/data/authentik";
        backupDir = "/data/backups/authentik";
        mediaDir = "/vault/authentik/media";
        envFile = config.age.secrets.authentikEnv.path;
        ldap = {
          enable = true;
          ldapPort = 9389;
          ldapsPort = 9636;
          metricsPort = 9301;
        };
      };

      caddy = {
        enable = true;
        openFirewall = true;
        dataDir = "/data/caddy";
        email = "xavgroleau@gmail.com";
        reverseProxies = {
          "authentik.${domain}" = "localhost:9000";

          "immich.${domain}" = "localhost:10300";

          "ocis.${domain}" = "localhost:11200";
          "wopi.${domain}" = "localhost:11210";
          "collabora.${domain}" = "localhost:11220";

          "jellyfin.${domain}" = "localhost:8096";
          "jellyseerr.${domain}" = "localhost:5055";

          "overseerr.${domain}" = "unraid:5055"; # Temporary
          "overseerr.sheogorath.duckdns.org" = "unraid:5055"; # Temporary
        };
      };

      immich = {
        enable = true;
        port = 10300;
        configDir = "/vault/immich";
        dataDir = "/documents/immich";
        backupDir = "/data/backups/immich";
        databaseDir = "/data/immich/database";
        envFile = config.age.secrets.immichEnv.path;
      };

      media-server = {
        enable = true;
        dataDir = "/vault/media-server";
        downloadDir = "/media/deluge-downloads";
        mediaDir = "/media/media";
        ovpnFile = config.age.secrets.piaOvpn.path;
      };

      ocis = {
        enable = true;
        collabora = {
          enable = true;
          wopiDomain = "wopi.${domain}";
          wopiPort = 11210;
          collaboraDomain = "collabora.${domain}";
          collaboraPort = 11220;
        };
        port = 11200;
        configDir = "/vault/ocis";
        dataDir = "/documents/ocis";
        environmentFiles = [ config.age.secrets.ocisEnv.path ];
        domain = "ocis.${domain}";
      };

      msmtp = {
        enable = true;
        host = "mail.gmx.com";
        from = "sheogorath@gmx.com";
        to = "xavgroleau@gmail.com";
        username = "xavgroleau@gmx.com";
        passwordFile = config.age.secrets.gmxPass.path;
      };

      palworld = {
        enable = true;
        restart = true;
        port = 8211;
        openFirewall = true;
        dataDir = "/data/palworld";
      };

    };

    services = {
      borgbackup.jobs."unraid" = {
        paths = [ "/vault" "/documents" "/data/backups" ];
        exclude = [ ];
        repo = "ssh://borg@unraid:2222/backup/sheogorath";
        encryption = { mode = "none"; };
        environment.BORG_RSH = "ssh -i /etc/ssh/ssh_host_ed25519_key";
        compression = "auto,lzma";
        startAt = "daily";
        postHook = ''
          if [ $exitStatus -ne 0 ]; then
             echo -e "From: sheogorath@gmx.com\nTo: xavgroleau@gmail.com\nSubject: Borg unraid\n\nFailed to backup borg job unraid with exitcode $exitStatus\n" | ${pkgs.msmtp}/bin/msmtp -a default xavgroleau@gmail.com
          fi
        '';
      };

      cloudflare-dyndns = {
        enable = true;
        deleteMissing = false;
        domains = [ domain ];
        apiTokenFile = config.age.secrets.cloudflareXgroleau.path;
      };

      duplicati = {
        enable = true;
        port = 14000;
      };

      fail2ban.enable = true;

    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Use the systemd-boot EFI boot loader.
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    networking = {
      useDHCP = true;
      hostId = "819a6cd7";
      hostName = "sheogorath";
    };

    # nfs mounts
    fileSystems."/mnt/nfs/shows" = {
      device = "unraid:/shows";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };

    fileSystems."/mnt/nfs/movies" = {
      device = "unraid:/movies";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };

    system.stateVersion = "23.11";
  };
}
