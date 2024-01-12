{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.networking.kdeconnect;
in {

  options.modules.networking.kdeconnect = with types; {
    enable = mkEnableOption "Enables the kde connect service";
  };

  config = mkIf cfg.enable {
    networking.firewall = rec {
      allowedTCPPortRanges = [{
        from = 1714;
        to = 1764;
      }];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
  };
}
