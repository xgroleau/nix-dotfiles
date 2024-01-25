{ config, pkgs, ... }:

let hostname = "jyggalag";
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
          "ocis.sheogorath.duckdns.org" = "localhost:9200";
          "overseerr.sheogorath.duckdns.org" = "192.168.1.110:5055"; # Temporary
        };
      };

      immich = {
        enable = true;
        port = 9300;
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
        port = 9200;
        configDir = "/vault/ocis";
        dataDir = "/documents/ocis";
        url = "https://ocis.sheogorath.duckdns.org";
      };

      palworld = {
        enable = true;
        openFirewall = true;
        port = 8211;
        dataDir = "/data/palworld";
      };

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
