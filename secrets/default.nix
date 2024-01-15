{ options, config, inputs, lib, pkgs, ... }:

with lib;
with lib.types;
with lib.my.option;
let cfg = config.modules.secrets;
in {

  options.modules.secrets = with types; {
    enable = mkEnableOption "Enables secrets management";
  };

  config = mkIf cfg.enable {
    age = {
      secrets = {
        duckdnsToken.file = ./duckdns-token.age;
        ghRunner.file = ./gh-runner.age;
        piaUsername.file = ./pia-user.age;
        piaPassword.file = ./pia-pass.age;
        piaOvpn.file = ./pia-ovpn.age;
      };
    };
  };
}
