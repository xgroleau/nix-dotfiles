{ config, lib, pkgs, nixpkgs, ... }:

let keys = import ../secrets/ssh-keys.nix;
in {
  config = {

    # Custom modules
    modules = { tailscale.enable = true; };

    nixpkgs.config.allowUnfree = true;
    nix = {
      package = pkgs.nixUnstable;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';

      # Avoid always redownloading the registry
      registry.nixpkgs.flake = nixpkgs; # For flake commands
      nixPath = [ "nixpkgs=${nixpkgs}" ]; # For legacy commands
    };

    time.timeZone = "America/Toronto";
    environment.systemPackages = with pkgs; [ vim nano curl wget ];

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

        openssh.authorizedKeys.keys = [ keys.user.xgroleau ];
      };

      users.root = { openssh.authorizedKeys.keys = [ keys.user.xgroleau ]; };
    };
  };
}
