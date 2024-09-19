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
    enable = lib.mkEnableOption "valheim";

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
      description = "Where on disk to store your valheim directory";
    };

  };

  config = lib.mkIf cfg.enable {
    minecraft-servers.servers."${cfg.name}" = {
      enable = true;
      eula = true;
      autostart = true;
      enableReload = true;
      restart = "always";
      openFirewall = cfg.openFirewall;
      package = pkgs.fabricServers.fabric-1_21;

      dataDir = cfg.dataDir;
      runDir = cfg.dataDir;

      serverProperties = {
        enable-command-block = true;
        enforce-whitelist = true;
        gamemode = "survival";
        generate-structures = "true";
        hide-online-players = false;
        initial-enabled-packs = "vanilla";
        level-name = cfg.name;
        motd = "${cfg.name} server :)";
        online-mode = false;
        pvp = true;
        require-resource-pack = false;
        # resource-pack=
        # resource-pack-id=
        # resource-pack-prompt=
        # resource-pack-sha1=
        server-port = cfg.port;
        white-list = false;
      };
      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            vicPointBlank = pkgs.lib.fetchurl {
              url = "https://cdn.modrinth.com/data/og4KPYmA/versions/HiwllvyQ/pointblank-fabric-1.21-1.6.7.jar";
              sha512 = "562c87a50f380c6cd7312f90b957f369625b3cf5f948e7bee286cd8075694a7206af4d0c8447879daa7a3bfe217c5092a7847247f0098cb1f5417e41c678f0c1";
            };
          }
        );
      };
    };

    # Create the folder if it doesn't exist
    systemd.tmpfiles.settings."mineraft-${cfg.name}" = {
      "${cfg.dataDir}/data" = {
        d = {
          user = "root";
          mode = "777";
        };
      };
      "${cfg.dataDir}/run" = {
        d = {
          user = "root";
          mode = "777";
        };
      };

    };

  };

}
