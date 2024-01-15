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

    authUserPassFile = mkOption {
      description = "Path to auth-user-pass file";
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

    modules.networking.forced-vpn = {
      enable = true;
      servers."${group}" = {
        ovpnFile = cfg.ovpnFile;
        authUserPass = cfg.authUserPassFile;
        mark = "0x6";
        protocol = "udp";
        routeTableId = 42;
        users = [ config.services.jackett.user config.services.deluge.user ];
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
