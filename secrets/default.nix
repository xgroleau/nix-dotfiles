{ options, config, inputs, lib, pkgs, ... }:

with lib;
with lib.types;
with lib.my.option;
let cfg = config.modules.secrets;
in {

  options.modules.secrets = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    age = {
      secrets = {
        duckdnsToken.file = ./duckdns-token.age;
        ghRunner.file = ./gh-runner.age;
      };
    };
  };
}
