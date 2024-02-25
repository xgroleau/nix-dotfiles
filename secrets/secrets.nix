let keys = import ./ssh-keys.nix;
in with keys; {
  "duckdns-token.age".publicKeys = [ users.xgroleau machines.jyggalag ];
  "gh-runner.age".publicKeys = [ users.xgroleau machines.jyggalag ];
  "pia-ovpn.age".publicKeys = [ users.xgroleau machines.sheogorath ];
  "authentik-env.age".publicKeys = [ users.xgroleau machines.sheogorath ];
  "immich-env.age".publicKeys = [ users.xgroleau machines.sheogorath ];
  "gmx-pass.age".publicKeys = [ users.xgroleau machines.sheogorath ];
  "alertmanager-env.age".publicKeys = [ users.xgroleau machines.sheogorath ];
  "cloudflare-xgroleau.age".publicKeys = [ users.xgroleau machines.sheogorath ];
  "ocis-env.age".publicKeys = [ users.xgroleau machines.sheogorath ];
}
