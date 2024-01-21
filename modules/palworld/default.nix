{ config, pkgs, lib, ... }:
let
  inherit (lib) mdDoc mkIf mkEnableOption mkOption;
  inherit (lib.types) path port str number;
  cfg = config.modules.palworld;
  join = builtins.concatStringsSep " ";
in {
  imports = [ ];

  options.modules.palworld = {
    enable = mkEnableOption "palworld";
    dataDir = mkOption {
      type = path;
      default = "/var/lib/palworld";
      description = "where on disk to store your palworld directory";
    };
    port = mkOption {
      type = port;
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
          ports = [ "${cfg.port}:8112" ];
          volumes = [ "${cfg.dataDir}:/serverdata/serverfiles" ];
          extraOptions = [ "--cap-add=NET_ADMIN" "--privileged=true" ];
          environment = {
            STEAMCMD_DIR = "/serverdata/steamcmd";
            SERVER_DIR = "/serverdata/serverfiles";
            GAME_ID = 2394010;
            UPDATE_PUBLIC_IP = "false";
            GAME_NAME = "Palworld-Yofo";
            GAME_PARAMS = "EpicApp=PalServer";
            GAME_PARAMS_EXTRA =
              "-No-useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS";
            UID = "99";
            GID = "100";
            GAME_PORT = "27015";
            VALIDATE = "";
            USERNAME = "";
            PASSWRD = "";
          };
        };
      };
    };

    # Expose ports for container
    networking.firewall = { allowedUDPPorts = lib.mkForce [ cfg.port ]; };

  };
}
