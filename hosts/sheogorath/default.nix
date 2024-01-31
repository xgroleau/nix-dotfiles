{ config, pkgs, ... }:

let domain = "xgroleau.com";
in {
  imports = [ ../base-config.nix ./disko.nix ./hardware-configuration.nix ];

  config = {
    # Custom modules
    modules = {
      home.username = "xgroleau";
      home.profile = "minimal";
      ssh.enable = true;
      secrets.enable = true;

      authentik = {
        enable = true;
        envFile = config.age.secrets.authentikEnv.path;
        dataDir = "/data/authentik";
        port = 9000;
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
          "overseerr.${domain}" = "192.168.1.110:5055"; # Temporary
        };
      };

      immich = {
        enable = true;
        port = 10300;
        configDir = "/vault/immich";
        dataDir = "/documents/immich";
        databaseDir = "/data/immich/database";
        envFile = config.age.secrets.immichEnv.path;
      };

      media-server = {
        enable = true;
        data = "/vault/media-server";
        download = "/media/deluge-downloads";
        ovpnFile = config.age.secrets.piaOvpn.path;
      };

      ocis = {
        enable = true;
        port = 11200;
        configDir = "/vault/ocis";
        dataDir = "/documents/ocis";
        url = "https://ocis.${domain}";
      };

      msmtp = {
        enable = true;
        host = "mail.gmx.com";
        from = "sheogorath@gmx.com";
        to = "xavgroleau@gmail.com";
        username = "xavgroleau@gmx.com";
        passwordFile = config.age.secrets.msmtpPass.path;
      };

      palworld = {
        enable = true;
        openFirewall = true;
        port = 8211;
        dataDir = "/data/palworld";
      };

    };

    services.cloudflare-dyndns = {
      enable = true;
      deleteMissing = false;
      domains = [ domain ];
      apiTokenFile = config.age.secrets.cloudflareXgroleau.path;
    };

    services.borgbackup.jobs."unraid" = {
      paths = [ "/vault" "/documents" "/data/backups" ];
      exclude = [ ];
      repo = "ssh://borg@unraid:2222/backup/sheogorath";
      encryption = { mode = "none"; };
      environment.BORG_RSH = "ssh -i /etc/ssh/ssh_host_ed25519_key";
      compression = "auto,lzma";
      startAt = "daily";
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

    system.stateVersion = "24.05";
  };
}
