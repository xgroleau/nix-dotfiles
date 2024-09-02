let
  keys = import ./ssh-keys.nix;
in
with keys;
{
  "alertmanager-env.age".publicKeys = [
    users.xgroleau
    machines.jyggalag
  ];
  "authentik-env.age".publicKeys = [
    users.xgroleau
    machines.sheogorath
  ];
  "cloudflare-xgroleau.age".publicKeys = [
    users.xgroleau
    machines.sheogorath
  ];
  "firefly-appkey.age".publicKeys = [
    users.xgroleau
    machines.sheogorath
  ];
  "firefly-importer-token.age".publicKeys = [
    users.xgroleau
    machines.sheogorath
  ];
  "duckdns-token.age".publicKeys = [
    users.xgroleau
    machines.jyggalag
  ];
  "gmx-pass.age".publicKeys = [
    users.xgroleau
    machines.sheogorath
  ];
  "immich-env.age".publicKeys = [
    users.xgroleau
    machines.sheogorath
  ];
  "mealie-env.age".publicKeys = [
    users.xgroleau
    machines.sheogorath
  ];
  "ocis-env.age".publicKeys = [
    users.xgroleau
    machines.sheogorath
  ];
  "pia-ovpn.age".publicKeys = [
    users.xgroleau
    machines.sheogorath
  ];
}
