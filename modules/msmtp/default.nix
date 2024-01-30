{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.msmtp;
in {

  options.modules.msmtp = {
    enable = mkEnableOption
      "Enables msmtp to send emails and notifications. Also enables system notification to an email";
    host = mkReq types.str "Host to use";
    from = mkReq types.str "Email to use to send";
    username = mkReq types.str "Username to authenticate";
    passwordFile = mkReq types.str "Path to the password file";
    port = mkOpt' types.port 587 "The port to use to send the email";
    to =
      mkReq types.str "Email to receive system notificaiton (e.g. zfs errors)";
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

    services.zfs.zed = {
      enableMail = false;
      settings = {
        ZED_DEBUG_LOG = "/tmp/zed.debug.log";
        ZED_EMAIL_ADDR = [ cfg.to ];
        ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
        ZED_EMAIL_OPTS = "@ADDRESS@";

        ZED_NOTIFY_INTERVAL_SECS = 3600;
        ZED_NOTIFY_VERBOSE = false;

        ZED_USE_ENCLOSURE_LEDS = true;
        ZED_SCRUB_AFTER_RESILVER = true;
      };
    };

  };
}
