{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.ssh;
in {

  options.modules.ssh = with types; {
    enable = mkEnableOption "Enable a ssh server";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };
}
