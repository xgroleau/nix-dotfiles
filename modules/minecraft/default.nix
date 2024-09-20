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
      runDir = "${cfg.dataDir}";

      eula = true;

      servers."${cfg.name}" = {
        enable = true;
        autoStart = true;
        restart = "always";
        openFirewall = cfg.openFirewall;
        package = pkgs.fabricServers.fabric-1_21_1.override { loaderVersion = "0.15.11"; };

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
              frabricAPI = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/qKPgBeHl/fabric-api-0.104.0%2B1.21.1.jar";
                sha512 = "0773f45d364b506b4e5b024aa8f1d498900fcf0a020d2025154e163e50a0eeee1b8296bf29c21df5ced42126ed46635e5ed094df25796ec552eb76399438e7e7";

              };

              # VPC dep
              geckoLib = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/8BmcQJ2H/versions/5jcq814u/geckolib-fabric-1.21.1-4.6.5.jar";
                sha512 = "f8275fc0fe9cdd9e598bf3b0ad94313f89092abb95c5a03ae3f37ac1a24a01d6630d1af962079b264ec2f976ef581f134ca0dd0c7b95ebf6242efb2f9472d28f";
              };
              vicPointBlank = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/og4KPYmA/versions/HiwllvyQ/pointblank-fabric-1.21-1.6.7.jar";
                sha512 = "d02b4e037c2a5863978f2a7535c920b3fe39fcb6b7603c1c23e0597daad41ab038c014aa02d0414aa4c2b1a67d237c575458d70adee89cc0e2b8f8967e3d8efd";
              };

              appleSkin = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/fG1xJao0/appleskin-fabric-mc1.21-3.0.5.jar";
                sha512 = "32176384779f6e223ce6c68bfa3c505222be0d5a21606a195562b471d29b2f7af253bb42756dd66373475bb75582fc11c72d8bd2f311bd0f0ad06816e4f61a29";
              };
            }
          );
        };
      };

    };
    # Create the folder if it doesn't exist
    systemd.tmpfiles.settings."mineraft-${cfg.name}" = {
      "${cfg.dataDir}" = {
        d = {
          user = "minecraft";
          group = "minecraft";
          mode = "755";
        };
      };

      "${cfg.dataDir}/data" = {
        d = {
          user = "minecraft";
          group = "minecraft";
          mode = "755";
        };
      };
    };

  };

}
