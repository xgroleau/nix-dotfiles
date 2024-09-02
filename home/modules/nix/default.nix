{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.nix;
in
{

  options.modules.nix = {
    builders = lib.mkEnableOption "Enable common nixpkgs configurations";
  };

  config = lib.mkIf cfg.builders {
    nix.settings = {
      builders = ''ssh-ng://builder@sheogorath x86_64-linux - 1 2 nixos-test,benchmark,big-parallel,kvm - -; ssh-ng://builder@jyggalag aarch64-linux - 1 2 - - -'';
    };
  };
}
