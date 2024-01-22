# Huge thanks to @Zumorica for creating the initial module:
# https://github.com/Zumorica/GradientOS/blob/main/hosts/asiyah/palworld-server.nix
{ config, pkgs, lib, ... }:

with lib;
with lib.my.option;
let
  cfg = config.modules.palworld2;
  steam-id = "2394010";
in {
  options.modules.palworld2 = {
    enable = mkEnableOption "palworld";
    dataDir = mkReq types.str "Path where the data will be stored";
    port = mkOption {
      type = types.port;
      default = 8211;
      description = "the port to use";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.palworld = {
      description = "Palworld Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      requires = [ "network.target" ];
      environment.HOME = cfg.dataDir;

      path = with pkgs; [ steamcmd steam-run ];

      preStart = ''
        steamcmd \
          +force_install_dir ${cfg.dataDir} \
          +login anonymous \
          +app_update ${steam-id} validate \
          +quit
      '';

      script = ''
        mkdir -p .steam/sdk64/
        cp linux64/steamclient.so .steam/sdk64/steamclient.so
        steam-run \
          ${cfg.dataDir}/PalServer.sh \
            -useperfthreads \
            -NoAsyncLoadingThread \
            -UseMultithreadForDS
      '';

      serviceConfig = {
        User = "palworld";
        Group = "palworld";
        Restart = "on-failure";

        StateDirectory = "palworld";
        WorkingDirectory = cfg.dataDir;

        TimeoutStartSec = "1h";

        ProcSubset = "all";
        RestrictNamespaces = false;
        SystemCallFilter = [ ];
      };
    };

    users.users.palworld = {
      group = "palworld";
      isSystemUser = true;
    };
    users.groups.palworld = { };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
    networking.firewall.allowedUDPPorts = [ cfg.port ];
  };
}
