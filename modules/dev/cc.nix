{ config, options, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.dev.cc;
in {

  options.modules.dev.cc = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { home.packages = with pkgs; [ clang gdb cmake ]; };
}
