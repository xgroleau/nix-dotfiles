{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let
  cfg = config.modules.services.media-server;
  group = "media";
in {
  options.modules.services.media-server = {
    enable = mkEnableOption "A media server configuration";

    data = mkReq types.str "Path where the data will be stored";

    download = mkReq types.str "Path where the download will be stored";

    ovpnFile = mkReq types.str
      "Path to ovpn config file, auth needs to be embedded in the file";

  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        delugevpn = {
          user = "delugevpn";
          autoStart = true;
          image = "binhex/arch-delugevpn";
          ports = [ "8112:8112" "8118:8118" "58846:58846" "58946:58946" ];
          volumes = [
            "${cfg.data}/deluge:/data"
            "${cfg.download}:/download"
            "${cfg.ovpnFile}:/config/vpn.ovpn"
          ];
          environment = {
            VPN_ENABLED = "yes";
            VPN_PROV = "custom";
            VPN_CLIENT = "openvpn";
            STRICT_PORT_FORWARD = "yes";
            ENABLE_PRIVOXY = "yes";
            LAN_NETWORK = "10.0.0.0/8,172.16.0.0/12,192.168.0.0/16";
            NAME_SERVERS =
              "84.200.69.80,37.235.1.174,1.1.1.1,37.235.1.177,84.200.70.40,1.0.0.1,8.8.8.8";
            DELUGE_DAEMON_LOG_LEVEL = "info";
            DELUGE_WEB_LOG_LEVEL = "info";
            DELUGE_ENABLE_WEBUI_PASSWORD = "yes";
            VPN_INPUT_PORTS = "";
            VPN_OUTPUT_PORTS = "";
            DEBUG = "false";
            UMASK = "000";
            PUID = "0";
            PGID = "0";
          };
        };
      };
    };
    # Create a directory in the service
    systemd.tmpfiles.rules = [
      "d ${cfg.data}/deluge 0770 ${virtualisation.oci-containers.containers.delugevpn.user} ${group} -"
    ];

    # Expose ports
    networking.firewall = {
      allowedTCPPorts = lib.mkForce [ 8112 8118 58846 58946 ];
      allowedUDPPorts = lib.mkForce [ 8112 8118 58846 58946 ];
    };

    services.prowlarr = {
      enable = true;
      openFirewall = true;
    };

    services.lidarr = {
      inherit group;
      enable = true;
      openFirewall = true;
      dataDir = cfg.data + "/lidarr";
    };

    services.plex = {
      inherit group;
      enable = true;
      openFirewall = true;
      dataDir = cfg.data + "/plex";
    };

    services.sonarr = {
      inherit group;
      enable = true;
      openFirewall = true;
      dataDir = cfg.data + "/sonarr";
    };

    services.radarr = {
      inherit group;
      enable = true;
      openFirewall = true;
      dataDir = cfg.data + "/radarr";
    };

    # And overwrite prowlarr's default systemd unit to run with the correct user/group
    systemd.services.prowlarr = {
      serviceConfig = {
        User = "prowlarr";
        Group = "media";
      };
    };

    users.groups.media.members = (with config.services; [
      deluge.user
      sonarr.user
      radarr.user
      plex.user
      lidarr.user
    ]);
  };
}