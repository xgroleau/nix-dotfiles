{ config, lib, pkgs, flakeInputs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.authentik;
in {

  imports = [ ];

  options.modules.authentik = {
    enable = mkEnableOption
      "Enables the authentik module, uses a nixos container under the hood so the postges db is a seperated service";
    envFile = mkReq types.str "Path to the environment file";
    dbDataDir = mkReq types.str "Path to the database data directory";
    port = mkOption {
      type = types.port;
      default = 9000;
      description = "the port for http access";
    };
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

        "${cfg.dbDataDir}" = {
          hostPath = cfg.dbDataDir;
          isReadOnly = false;
        };
      };

      forwardPorts = [{
        hostPort = cfg.port;
        protocol = "tcp";
      }];

      config = _: {
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
          postgresql.dataDir = cfg.dbDataDir;

        };

        system.stateVersion = "24.05";
      };
    };

    systemd.tmpfiles.settings.authentik = {
      "${cfg.dbDataDir}" = {
        d = {
          user = "postgres";
          group = "postgres";
          mode = "770";
        };
      };
    };

  };
}
