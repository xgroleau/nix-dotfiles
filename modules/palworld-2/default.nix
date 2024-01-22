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
    users.users.palworld = {
      isSystemUser = true;
      home = cfg.dataDir;
      createHome = true;
      homeMode = "750";
      group = config.users.groups.palworld.name;
    };

    users.groups.palworld = { };

    systemd.tmpfiles.rules = [
      "d ${config.users.users.palworld.home}/.steam 0755 ${config.users.users.palworld.name} ${config.users.groups.palworld.name} - -"
      "L+ ${config.users.users.palworld.home}/.steam/sdk64 - - - - /var/lib/steamcmd/apps/1007/linux64"
    ];

    systemd.services.palworld = {
      path = [ pkgs.xdg-user-dirs ];

      # Manually start the server if needed, to save resources.
      wantedBy = [ ];

      # Install the game before launching.
      wants = [ "steamcmd@${steam-id}.service" ];
      after = [ "steamcmd@${steam-id}.service" ];

      serviceConfig = {
        ExecStart = lib.escapeShellArgs [
          "${pkgs.steam-run}/bin/steam-run"
          "/var/lib/steamcmd/apps/${steam-id}/PalServer.sh"
          "port=${toString cfg.port}"
          "-useperfthreads"
          "-NoAsyncLoadingThread"
          "-UseMultithreadForDS"
        ];
        Nice = "-5";
        PrivateTmp = true;
        Restart = "on-failure";
        User = config.users.users.palworld.name;
        WorkingDirectory = "~";
      };
      environment = { SteamAppId = "${toString steam-id}"; };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
    networking.firewall.allowedUDPPorts = [ cfg.port ];
  };
}
