{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.networking.duckdns;
in {

  options.modules.networking.duckdns = with types; {
    enable = mkBoolOpt false;
    domain = mkReq types.nonEmptyStr "The domain to register";
    tokenFile = mkReq types.path ''
      The full path to a file which contains the token for the domain.
       The file should contain exactly one line with the token without any newline.'';
  };

  config = mkIf cfg.enable {
    systemd.timers.duckdns = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "5m";
        Unit = "duckdns.service";
      };
    };

    systemd.services.duckdns = {
      script = ''
        set -eu
        "${pkgs.curl}/bin/curl https://www.duckdns.org/update?domains=${cfg.domain}&token=$(${pkgs.coreutils}/bin/cat ${cfg.tokenFile})&ip= >/dev/null 2>&1"
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}
