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

    openFirewall = mkBoolOpt' false "Open the required ports in the firewall";

    user = mkOpt' types.str "palworld" "User account under which palworld runs";

    group = mkOpt' types.str "palworld" "Group under which palworld runs";

    dataDir = mkOpt' types.path "/var/lib/palworld"
      "Where on disk to store your palworld directory";

    port = mkOpt' types.port 8211 "the port to use";

    maxPlayers = mkOpt' types.number 32 "The max amount of players to support";
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      inherit (cfg) group;
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
    };
    users.groups.${cfg.group} = { };

    systemd = {
      services = {
        palworld = {
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

            # Palworld has a massive memoryleak, let's limit the memory to keep the system up
            MemoryMax = "16G";

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

        palworld-restart = {
          description = "Restart palworld";
          wantedBy = [ "multi-user.target" ];
          script = ''
            systemctl restart palworld.service
          '';
          serviceConfig = {
            User = "root";
            Type = "oneshot";
          };

        };
      };

      timers.palworld-restart = {
        wantedBy = [ "timers.target" ];
        partOf = [ "palworld.service" ];
        timerConfig = { OnCalendar = [ "*-*-* 04:30:00" ]; };
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedUDPPorts = [
        cfg.port
        (cfg.port + 1) # For steam discovery
      ];
    };

  };
}
