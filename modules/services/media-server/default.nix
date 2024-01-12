{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.networking.duckdns;
  group = "media";
in {
  options.veritas.profiles.media-server = {
    enable = mkEnableOption "A media server configuration";

    downloadPath = mkReq types.string "Path where the download will be done";
  };

  config = mkIf cfg.enable {
    services.deluge = {
      inherit group;
      enable = true;
      extraPackages = [ pkgs.unrar ];
      web = {
        enable = true;
        openFirewall = true;
      };
    };

    services.jackett = {
      inherit group;
      enable = true;
      openFirewall = true;
      package = pkgs.jackett;
    };

    services.lidarr = {
      inherit group;
      enable = true;
      openFirewall = true;
      package = pkgs.lidarr;
    };

    services.plex = {
      inherit group;
      enable = true;
      openFirewall = true;
      package = pkgs.plexPass;
    };

    services.sonarr = {
      inherit group;
      enable = true;
      openFirewall = true;
    };

    services.radarr = {
      inherit group;
      enable = true;
      openFirewall = true;
    };

    veritas.services.per-user-vpn = {
      enable = true;
      servers."${group}" = {
        ovpnFile = config.age.secrets.pia-ovpn.path;
        credentials = {
          username = config.age.secrets.pia-user.path;
          password = config.age.secrets.pia-password.path;
        };
        mark = "0x1";
        protocol = "udp";
        routeTableId = 42;
        users = [ config.services.jackett.user config.services.deluge.user ];
      };
    };

    users.groups.media.members =
      [ users.users.${config.modules.home.username}.name ]
      ++ (with config.services; [
        deluge.user
        sonarr.user
        radarr.user
        plex.user
        lidarr.user
      ]);
  };
}
