{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.pomerium;
in {

  options.modules.pomerium = with types; {
    enable = mkEnableOption
      "Pomerium, enable to use pomerium idenity aware access proxy";
    envFile = mkReq types.str
      "Environment file, needs to provided at least IDP_PROVIDER, IDP_CLIENT_ID, IDP_CLIENT_SECRET and AUTHENTICATE_SERVICE_URL";
  };

  config = mkIf cfg.enable {
    services.pomerium = {
      enable = true;
      secretsFile = cfg.envFile;

      settings = {
        autocert = true;
        address = ":443";
        http_redirect_addr = ":80";

        # jwt_claims_headers = {
        #   X-Pomerium-Claim-Email = "email";
        #   X-Pomerium-Claim-User = "user";
        #   X-Pomerium-Claim-Name = "name";
        # };

        routes = [{
          from = "https://test.sheogorath.duckdns.org";
          to = "http://localhost:8112";
          pass_identity_headers = true;
          policy = [{ allow."or" = [{ email.is = "xavgroleau@gmail.com"; }]; }];
        }];

      };
    };
  };
}
