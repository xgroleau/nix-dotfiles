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

      duckdns = {
        enable = true;
        domain = hostname;
        tokenFile = config.age.secrets.duckdnsToken.path;
      };

      media-server = {
        enable = true;
        data = "/data/media-server";
        download = "/media/deluge-downloads";
        ovpnFile = config.age.secrets.piaOvpn.path;
      };

      palworld = {
        enable = true;
        dataDir = "/data/palworld";
        port = 8211;
        maxPlayers = 32;
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
      hostId = "819a6cd7";
      hostName = "sheogorath";
      interfaces.enp0s25.useDHCP = true;
    };

    system.stateVersion = "24.05";
  };
}
