{ config, pkgs, lib, ... }:
with lib;
with lib.my.option;
let
  group = "palworld";
  cfg = config.modules.palworld;
in {
  imports = [ ];

  options.modules.palworld = {
    enable = mkEnableOption "palworld";
    dataDir = mkReq types.str "Path where the data will be stored";
    steamCmdDir = mkReq types.str "Path for the SteamCmdDirectory";
    port = mkOption {
      type = types.port;
      default = 8211;
      description = "the port to use";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        palworld = {
          autoStart = true;
          image = "ich777/steamcmd:palworld";
          ports = [ "${toString cfg.port}:8112" ];
          volumes = [
            "${cfg.dataDir}:/serverdata/serverfiles"
            "${cfg.steamCmdDir}:/serverdata/steamcmd"
          ];
          extraOptions = [ "--cap-add=NET_ADMIN" "--privileged=true" ];
          environment = {
            STEAMCMD_DIR = "/serverdata/steamcmd";
            SERVER_DIR = "/serverdata/serverfiles";
            GAME_ID = "2394010";
            UPDATE_PUBLIC_IP = "false";
            GAME_NAME = "palworld";
            GAME_PARAMS = "EpicApp=PalServer";
            GAME_PARAMS_EXTRA =
              "-No-useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS";
            UID = "99";
            GID = "100";
            GAME_PORT = "8112";
            VALIDATE = "";
            USERNAME = "";
            PASSWRD = "";
          };
        };
      };
    };

    # Expose ports for container
    networking.firewall = { allowedUDPPorts = lib.mkForce [ cfg.port ]; };

    users.groups.palworld = { };

    # Create a directory for the container to properly start
    systemd.tmpfiles.settings.palworld = {
      "${cfg.dataDir}" = {
        d = {
          inherit group;
          mode = "0755";
          user = "root";
        };
      };
      "${cfg.steamCmdDir}" = {
        d = {
          inherit group;
          mode = "0755";
          user = "root";
        };
      };
    };

  };
}
