{ config, pkgs, lib, ... }:

with lib;
with lib.my.option;
let
  cfg = config.modules.palworld;
  join = builtins.concatStringsSep " ";
in {
  imports = [ ];

  options.modules.palworld = {
    enable = mkEnableOption "palworld";
    user = mkOption {
      type = types.str;
      default = "palworld";
      description = mdDoc "User account under which palworld runs";
    };
    group = mkOption {
      type = types.str;
      default = "palworld";
      description = mdDoc "Group under which palworld runs";
    };
    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/palworld";
      description = "where on disk to store your palworld directory";
    };
    port = mkOption {
      type = types.port;
      default = 8211;
      description = "the port to use";
    };
    maxPlayers = mkOption {
      type = types.number;
      default = 32;
      description = "the amount of players to support";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      inherit (cfg) group;
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
    };
    users.groups.${cfg.group} = { };

    systemd.services.palworld = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStartPre = join [
          "${pkgs.steamcmd}/bin/steamcmd"
          "+force_install_dir ${cfg.dataDir}"
          "+login anonymous"
          "+app_update 2394010"
          "+quit"
        ];
        ExecStart = join [
          "${pkgs.steam-run}/bin/steam-run ${cfg.dataDir}/Pal/Binaries/Linux/PalServer-Linux-Test Pal"
          "--port ${toString cfg.port}"
          "--players ${toString cfg.maxPlayers}"
          "--useperfthreads"
          "-NoAsyncLoadingThread"
          "-UseMultithreadForDS"
        ];
        Nice = "-5";
        Restart = "always";
        StateDirectory = "palworld:${cfg.dataDir}";
        User = cfg.user;
        WorkingDirectory = cfg.dataDir;
      };

      environment = {
        # linux64 directory is required by palworld.
        LD_LIBRARY_PATH = "linux64:${pkgs.glibc}/lib";
      };
    };

    networking.firewall = {
      allowedUDPPorts = lib.mkForce [
        cfg.port
        (cfg.port + 1) # For steam discovery
      ];
    };

  };
}
