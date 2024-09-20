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
    services.minecraft-servers = {
      enable = true;
      dataDir = "${cfg.dataDir}/data";
      runDir = "${cfg.dataDir}/${cfg.name}.sock";

      eula = true;

      servers."${cfg.name}" = {
        enable = true;
        autoStart = true;
        enableReload = true;
        restart = "always";
        openFirewall = cfg.openFirewall;
        package = pkgs.fabricServers.fabric-1_21;

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
              vicPointBlank = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/og4KPYmA/versions/HiwllvyQ/pointblank-fabric-1.21-1.6.7.jar";
                sha512 = "d02b4e037c2a5863978f2a7535c920b3fe39fcb6b7603c1c23e0597daad41ab038c014aa02d0414aa4c2b1a67d237c575458d70adee89cc0e2b8f8967e3d8efd";
              };
            }
          );
        };
      };

    };
    # Create the folder if it doesn't exist
    systemd.tmpfiles.settings."mineraft-${cfg.name}" = {
      "${cfg.dataDir}/data" = {
        d = {
          user = "minecraft";
          group = "minecraft";
          mode = "777";
        };
      };
    };

  };

}
