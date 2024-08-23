{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.nixpkgs;
in
{

  options.modules.nixpkgs = {
    enable = lib.mkEnableOption "Enable common nixpkgs configurations";
  };

  config = lib.mkIf cfg.enable {
    nix.settings = {
      builders = ''
        ssh-ng://xgroleau@sheogorath x86_64-linux - 1 2 nixos-test,benchmark,big-parallel,kvm - -;
        ssh-ng://xgroleau@jyggalag aarch64-linux - 1 2 - - -
      '';

    };
  };
}
