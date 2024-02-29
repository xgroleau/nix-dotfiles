{ options, config, inputs, lib, pkgs, ... }:

let
  cfg = config.modules.secrets;
  keys = import ./ssh-keys.nix;
  ageSecrets = import ./secrets.nix;

  # Get key or invalid key if doesn't exist in the ssh-keys.nix
  machineKey =
    keys.machines."${config.networking.hostName}" or "INVALID SSH KEY";

  # Filter for the secrets to only have the ones that have the host key
  filterSecrets = name: att:
    let keyName = builtins.baseNameOf att.file;
    in builtins.elem machineKey (ageSecrets."${keyName}".publicKeys);

  # attrset of the secrets
  secrets = {
    duckdnsToken.file = ./duckdns-token.age;
    ghRunner.file = ./gh-runner.age;
    piaOvpn.file = ./pia-ovpn.age;
    authentikEnv.file = ./authentik-env.age;
    immichEnv.file = ./immich-env.age;
    gmxPass.file = ./gmx-pass.age;
    alertmanagerEnv.file = ./alertmanager-env.age;
    cloudflareXgroleau.file = ./cloudflare-xgroleau.age;
    ocisEnv.file = ./ocis-env.age;
  };

  # Only secrets that have the machine ssh key in them
  filteredSecrets = lib.attrsets.filterAttrs filterSecrets secrets;

in {

  options.modules.secrets = {
    enable = lib.mkEnableOption "Enables secrets management";
  };

  config = lib.mkIf cfg.enable { age = { secrets = filteredSecrets; }; };
}

