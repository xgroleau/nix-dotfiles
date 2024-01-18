{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.pomerium;
in {

  options.modules.pomerium = with types; {
    enable = mkEnableOption
      "Pomerium, enable to use pomerium idenity aware access proxy";
  };

  config = mkIf cfg.enable { services.pomerium.enable = true; };
}
