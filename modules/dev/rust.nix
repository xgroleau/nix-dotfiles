{ config, options, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.dev.rust;
in {

  options.modules.dev.rust = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ pkgs.rustup ];

    home.sessionVariables = {
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
      PATH = [ "$CARGO_HOME/bin" ];
    };
  };

}
