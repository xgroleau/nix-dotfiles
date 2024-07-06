{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.modules.arkSurvivalAscended;

  containerBackendName = config.virtualisation.oci-containers.backend;

  containerBackend = pkgs."${containerBackendName}" + "/bin/" + containerBackendName;
in

{
  options.modules.arkSurvivalAscended = with lib.types; {
    enable = lib.mkEnableOption "Enables ark survival ascended server";

    openFirewall = lib.mkEnableOption "Open the required ports in the firewall";

    port = lib.mkOption {
      type = types.port;
      default = 7777;
      description = "The port to use";
    };

    serverDataDir = lib.mkOption {
      type = types.str;
      description = "Path to where the server data will be stored";
    };

    clusterDataDir = lib.mkOption {
      type = types.str;
      description = "Path to where the cluster data will be stored";
    };
  };

  config = lib.mkIf cfg.enable {

    virtualisation.oci-containers.containers = {
      asa-1 = {
        autoStart = true;
        image = "mschnitzer/asa-linux-server:latest";
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "asa-steam:/home/gameserver/Steam:rw"
          "asa-steamcmd:/home/gameserver/steamcmd:rw"
          "${cfg.serverDataDir}:/home/gameserver/server-files:rw"
          "${cfg.clusterDataDir}:/home/gameserver/cluster-shared:rw"
        ];

        environment = {
          PUID = "1000";
          PGID = "1000";

          ASA_START_PARAMS = "TheCenter_WP?listen?Port=7777?RCONPort=27020?RCONEnabled=True -WinLiveMaxPlayers=50 -clusterid=default -ClusterDirOverride=\"/home/gameserver/cluster-shared\"";
          ENABLE_DEBUG = "0";
        };

        ports = [ "${toString cfg.port}:7777/udp" ];
      };
    };

    networking.firewall = {
      allowedUDPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
    };

    systemd.tmpfiles.settings.arkSurvivalAscended = {
      "${cfg.serverDataDir}" = {
        d = {
          mode = "0777";
          user = "root";
        };
      };
      "${cfg.clusterDataDir}" = {
        d = {
          mode = "0777";
          user = "root";
        };
      };
    };
  };
}
