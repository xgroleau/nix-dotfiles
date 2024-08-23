{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  overlays = import ../overlays { inherit inputs; };
  keys = import ../secrets/ssh-keys.nix;
in
{
  imports = [
    ./modules/applications
    ./modules/desktop
    ./modules/dev
    ./modules/editors
    ./modules/nixpkgs
    ./modules/shell
    ./modules/nix
  ];

  config = {
    nixpkgs.overlays = [
      overlays.unstable-packages
      overlays.roam
    ];

    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
      userKnownHostsFile = "~/.ssh/known_hosts ~/.ssh/hm_hosts";
    };

    home.file.".ssh/hm_known_hosts" = {
      text = ''
        jyggalag ${keys.machines.jyggalag}
        sheogorath ${keys.machines.sheogorath}'';
    };

    # User config
    targets.genericLinux.enable = pkgs.stdenv.isLinux;
    systemd.user.startServices = true;
    nixpkgs.config.allowUnfree = true;
    manual.manpages.enable = false;

    home = {
      keyboard = {
        layout = "ca";
        options = [ "caps:swapescape" ];
      };

      enableNixpkgsReleaseCheck = true;
      language.base = "en_CA.UTF-8";
    };
  };
}
