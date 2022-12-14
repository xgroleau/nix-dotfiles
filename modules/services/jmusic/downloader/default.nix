{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.services.downloader;
in {

  options.modules.services.downloader = with types; {
    enable = mkBoolOpt false;
    dataDir = mkReq types.path ''
      The data directory of the downloads
    '';
  };

  config = mkIf cfg.enable { sevices.deluge = { enable = true; }; };
}
