{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.networking.tailscale;
in {

  options.modules.networking.tailscale = with types; {
    enable = mkEnableOption "Enables tailscale service and firewall";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ tailscale ];

    services.tailscale = {
      enable = true;
      openFirewall = true;
    };
  };
}
