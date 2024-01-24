{ config, lib, pkgs, flakeInputs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.authentik;
in {

  imports = [ ];

  options.modules.authentik = {
    enable = mkEnableOption
      "Enables the authentik module, uses a nixos container under the hood so the postges db is a seperated service";

    openFirewall = mkBoolOpt' false "Open the required ports in the firewall";

    envFile = mkReq types.str "Path to the environment file";

    dataDir = mkReq types.str "Path to the database data directory";

    port = mkOpt' types.port 9000 "the port for http access";
  };

  config = mkIf cfg.enable {
    containers.authentik = {
      autoStart = true;
      ephemeral = true;
      # Access to the host data
      bindMounts = {
        "${cfg.envFile}" = {
          hostPath = cfg.envFile;
          isReadOnly = true;
        };

        "${cfg.dataDir}" = {
          hostPath = cfg.dataDir;
          isReadOnly = false;
        };
      };

      forwardPorts = [{
        hostPort = cfg.port;
        protocol = "tcp";
      }];

      config = { ... }: {
        nixpkgs.pkgs = pkgs;
        imports = [ flakeInputs.authentik-nix.nixosModules.default ];
        services = {
          authentik = {
            enable = true;
            createDatabase = true;
            environmentFile = cfg.envFile;
            settings = {
              disable_startup_analytics = true;
              avatars = "gravatar,initials";
              listen = { http = "0.0.0.0:${toString cfg.port}"; };

            };
          };
          # Some override of the internal services
          postgresql.dataDir = "${cfg.dataDir}/postgres";

        };

        # Create the sub folder
        systemd.tmpfiles.settings.authentik = {
          "${cfg.dataDir}/postgres" = {
            d = {
              user = "postgres";
              group = "postgres";
              mode = "750";
            };
          };
        };

        system.stateVersion = "24.05";
      };
    };

    networking.firewall =
      mkIf cfg.openFirewall { allowedTcpPorts = [ cfg.port ]; };

    # Create the folder if it doesn't exist
    systemd.tmpfiles.settings.authentik = {
      "${cfg.dataDir}" = {
        d = {
          user = "root";
          mode = "777";
        };
      };
    };

  };
}
