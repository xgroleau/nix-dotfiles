{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.kdeconnect;
in {

  options.modules.kdeconnect = with types; {
    enable = mkEnableOption "Enables the kde connect service ports";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPortRanges = [{
        from = 1714;
        to = 1764;
      }];
      allowedUDPPortRanges = [{
        from = 1714;
        to = 1764;
      }];

    };
  };
}
