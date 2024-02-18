{ options, config, inputs, lib, pkgs, ... }:

let cfg = config.modules.secrets;
in {

  options.modules.secrets = {
    enable = lib.mkEnableOption "Enables secrets management";
  };

  config = lib.mkIf cfg.enable {
    age = {
      secrets = {
        duckdnsToken.file = ./duckdns-token.age;
        ghRunner.file = ./gh-runner.age;
        piaOvpn.file = ./pia-ovpn.age;
        authentikEnv.file = ./authentik-env.age;
        immichEnv.file = ./immich-env.age;
        gmxPass.file = ./gmx-pass.age;
        cloudflareXgroleau.file = ./cloudflare-xgroleau.age;
        ocisEnv.file = ./ocis-env.age;
      };
    };
  };
}
