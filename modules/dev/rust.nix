{ config, options, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.dev.rust;
in {

  options.modules.dev.rust = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ pkgs.rustup ];

    home.sessionVariables = {
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
    };
    home.sessionPath = [ "${config.home.sessionVariables.CARGO_HOME}/bin" ];
  };

}
