{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let
  cfg = config.modules.services.media-server;
  group = "media";
in {
  options.modules.services.media-server = {
    enable = mkEnableOption "A media server configuration";
    downloadPath = mkReq types.str "Path where the download will be done";

    ovpnFile = mkOption {
      description = "Path to ovpn config file";
      type = path;
    };

    ovpnUsernameFile = mkOption {
      description = "Path ovpn user file";
      type = path;
    };

    ovpnPasswordFile = mkOption {
      description = "Path ovpn password file";
      type = path;
    };

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
    };

    services.lidarr = {
      inherit group;
      enable = true;
      openFirewall = true;
    };

    services.plex = {
      inherit group;
      enable = true;
      openFirewall = true;
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

    # Run Binhex/DelugeVPN in dockern container.
    virtualisation.oci-containers = {
      backend = "docker";
      containers = {
        "delugevpn" = {
          image = "binhex/arch-delugevpn";
          extraOptions = [ "--cap-add=NET_ADMIN" ];
          ports = [ "8112:8112" "8118:8118" "58846:58846" "58946:58946" ];
          volumes = [
            "/home/nixos/torrents:/data"
            "/etc/nixos/configs/delugevpn:/config"
          ];
          environment = {
            VPN_ENABLED = "yes";
            VPN_USER = "myUser";
            VPN_PASS = "myPass";
            VPN_PROV = "custom";
            VPN_CLIENT = "openvpn";
            STRICT_PORT_FORWARD = "yes";
            ENABLE_PRIVOXY = "yes";
            LAN_NETWORK = "192.168.1.0/24";
            NAME_SERVERS = "1.1.1.1,8.8.8.8";
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

    users.groups.media.members = (with config.services; [
      deluge.user
      sonarr.user
      radarr.user
      plex.user
      lidarr.user
    ]);
  };
}
# { config, lib, pkgs, ... }:

# with lib;

# let
#   cfg = config.services.viaVpn;
# in
# {
#   options.services.viaVpn = {
#     enable = mkEnableOption "Force specific services to use VPN";

#     services = mkOption {
#       type = types.listOf types.str;
#       default = [];
#       example = [ "nginx" "ssh" ];
#       description = "List of services to force through VPN";
#     };

#     vpnInterface = mkOption {
#       type = types.str;
#       default = "tun0";
#       example = "tun0";
#       description = "VPN interface name";
#     };
#   };

#   config = mkIf cfg.enable {
#     networking.firewall.extraCommands = ''
#       # Ensure services can only communicate through VPN
#       ${concatStringsSep "\n" (map (service:
#         "iptables -A OUTPUT -m owner --uid-owner `id -u ${service}` -o ${cfg.vpnInterface} -j ACCEPT
#          iptables -A OUTPUT -m owner --uid-owner `id -u ${service}` ! -o ${cfg.vpnInterface} -j REJECT"
#       ) cfg.services)}
#     '';
#   };
# }
