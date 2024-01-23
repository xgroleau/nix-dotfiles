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
  };

  config = mkIf cfg.enable {
    containers.authentik = {
      autoStart = true;
      # Access to the host data
      bindMounts = {
        "${cfg.envFile}" = {
          hostPath = cfg.envFile;
          isReadOnly = true;
        };

        "${cfg.dbDataDir}" = { hostPath = cfg.envFile; };
      };

      # nixpkgs.pkgs = pkgs;
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
              avatars = "initials";
            };
          };

          # Some override of the internal services
          postgresql.dataDir = cfg.dbDataDir;

        };

        system.stateVersion = "24.05";
      };
    };
  };
}
