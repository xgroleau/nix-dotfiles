{ config, lib, pkgs, inputs, ... }:

let
  keys = import ../secrets/ssh-keys.nix;
  overlays = import ../overlays { inherit inputs; };
  gh_key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKUOB6V43misoDCzmVnVeuXJpCq/uHtPksVknOH67laS";
in {
  config = {

    # Custom modules
    modules = { tailscale.enable = true; };

    nixpkgs = {
      config.allowUnfree = true;
      overlays = [ overlays.unstable-packages overlays.roam ];
    };

    nix = {
      package = pkgs.nixUnstable;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';

      # Avoid always redownloading the registry
      registry.nixpkgs.flake = inputs.nixpkgs; # For flake commands
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ]; # For legacy commands
    };

    time.timeZone = "America/Toronto";
    environment.systemPackages = with pkgs; [ curl git vim nano wget ];

    programs.zsh.enable = true;
    i18n.defaultLocale = "en_CA.UTF-8";
    users = {
      users.xgroleau = {
        isNormalUser = true;
        shell = pkgs.zsh;
        initialPassword = "nixos";
        extraGroups = [
          "wheel"
          "audio"
          "networkmanager"

          # For embedded development
          "plugdev"
          "dialout"
        ];

        openssh.authorizedKeys.keys = [ keys.users.xgroleau ];
      };

      users.root = { openssh.authorizedKeys.keys = [ gh_key ]; };
    };

    #Increase number of file descriptor
    systemd.extraConfig = "DefaultLimitNOFILE=32768";

  };
}
