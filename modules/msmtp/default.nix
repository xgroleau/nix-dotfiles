{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.authentik;
in {

  options.modules.msmtp = {
    enable = mkEnableOption "Enables msmtp to send emails and notifications";
  };

  config = mkIf cfg.enable {
    programs.msmtp = {
      enable = true;
      default = {

        aliases = "/etc/aliases";
      };
      accounts = {
        default = {
          auth = true;
          tls = true;
          # try setting `tls_starttls` to `false` if sendmail hangs
          from = "<from address here>";
          host = "<hostname here>";
          user = "<username here>";
          passwordeval = "cat /secrets/smtp_password.txt";
        };
      };
    };

    environment.etc = {
      "aliases" = {
        text = ''
          root: me@example.com
        '';
        mode = "0644";
      };
    };

  };
}
