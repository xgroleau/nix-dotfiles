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

  config =
    lib.mkIf cfg.enable

      {
        services.minecraft-servers = {
          enable = true;
          dataDir = "${cfg.dataDir}/data";
          runDir = "${cfg.dataDir}";

          eula = true;

          servers."${cfg.name}" =
            let
              modpack = pkgs.fetchPackwizModpack {
                url = "https://gitlab.com/xavgroleau/yofo-mc-mods/-/raw/v1.0.1/pack.toml?ref_type=tags&inline=false";
                packHash = "sha256-i9UqnjWDZKvVF0BCB2xpDIw7QzMa4/XwgQConUH+63o=";
              };
              mcVersion = modpack.manifest.versions.minecraft;
              fabricVersion = modpack.manifest.versions.fabric;
              serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";
            in
            {

              enable = true;
              autoStart = true;
              restart = "always";
              openFirewall = cfg.openFirewall;

              package = pkgs.fabricServers.${serverVersion}.override { loaderVersion = fabricVersion; };
              symlinks = {
                "mods" = "${modpack}/mods";
              };

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
