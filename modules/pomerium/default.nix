{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.pomerium;
in {

  options.modules.pomerium = with types; {
    enable = mkEnableOption
      "Pomerium, enable to use pomerium idenity aware access proxy";
  };

  config = mkIf cfg.enable {
    services.pomerium = {
      enable = true;

      settings = {
        authenticate_service_url = "https://authenticate.pomerium.app";
        routes = [{
          from = "https://test.sheogorath.duckdns.org";
          to = "https://localhost:8112";
          pass_identity_headers = true;
          policy = [{ allow."or" = [{ email.is = "xavgroleau@gmail.com"; }]; }];
        }];

      };
    };
  };
}
