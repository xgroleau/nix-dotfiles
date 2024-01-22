let keys = import ./ssh-keys.nix;
in with keys; {
  "duckdns-token.age".publicKeys = [ users.xgroleau machines.jyggalag ];
  "gh-runner.age".publicKeys = [ users.xgroleau machines.jyggalag ];
  "pia-ovpn.age".publicKeys = [ users.xgroleau machines.sheogorath ];
  "pomerium-identity-provider.age".publicKeys =
    [ users.xgroleau machines.sheogorath ];
}
