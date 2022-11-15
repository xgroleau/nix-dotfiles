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
    services.cron = {
      enable = true;
      systemCronJobs = [
        "${pkgs.curl}/bin/curl https://www.duckdns.org/update?domains=${cfg.domain}&token=${
          builtins.readFile cfg.tokenFile
        }&ip= >/dev/null 2>&1"
      ];
    };
  };
}
