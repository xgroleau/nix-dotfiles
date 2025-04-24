{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.minecraft;
in

{

  options.modules.minecraft = with lib.types; {
    enable = lib.mkEnableOption "Minecraft";

    openFirewall = lib.mkEnableOption "Open the required ports in the firewall";

    port = lib.mkOption {
      type = types.port;
      default = 25565;
      description = "the port to use";
    };

    name = lib.mkOption {
      type = lib.types.str;
      default = "Minecraft";
      description = "Name for the server";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/minecraft";
      description = "Where on disk to store your minecraft directory";
    };

  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers.pixelmon = {
        autoStart = true;
        image = "itzg/minecraft-server";
        ports = [ "${toString cfg.port}:25565" ];
        environment = {
          EULA = "TRUE";
          PACKWIZ_URL = "https://raw.githubusercontent.com/xgroleau/yofo-modpack/refs/tags/v1.0.5/pack.toml";
          ONLINE_MODE = "FALSE";
          MOTD = "${cfg.name} server :)";
          SERVER_NAME = "${cfg.name}";
          TYPE = "FORGE";
          VERSION = "1.20.2";
        };

        volumes = [
          "${cfg.dataDir}/world:/data"
        ];
      };

    };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };

    # Create the folder if it doesn't exist
    systemd.tmpfiles.settings."mineraft-${cfg.name}" = {
      "${cfg.dataDir}" = {
        d = {
          user = "minecraft";
          group = "minecraft";
          mode = "755";
        };
      };
    };
  };

}
