{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.networking.ssh;
in {

  options.modules.networking.ssh = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      passwordAuthentication = false;
    };
  };
}
