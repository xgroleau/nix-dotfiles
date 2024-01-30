{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.msmtp;
in {

  options.modules.msmtp = {
    enable = mkEnableOption "Enables msmtp to send emails and notifications";
    host = mkReq types.str "Host to use";
    from = mkReq types.str "Email to use to send";
    username = mkReq types.str "Username to authenticate";
    passwordFile = mkReq types.str "Path to the password file";
    port = mkOpt' types.port 587 "The port to use to send the email";
  };

  config = mkIf cfg.enable {
    programs.msmtp = {
      enable = true;
      setSendmail = true;
      defaults = { aliases = "/etc/aliases"; };
      accounts = {
        default = {
          auth = true;
          tls = true;
          port = cfg.port;
          from = cfg.from;
          host = cfg.host;
          user = cfg.username;
          passwordeval = "cat ${cfg.passwordFile}";
        };
      };
    };

    environment.etc = {
      "aliases" = {
        text = ''
          root: ${cfg.from}
        '';
        mode = "0644";
      };
    };

  };
}
