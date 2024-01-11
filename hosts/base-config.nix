{ config, lib, pkgs, nixpkgs, ... }:

{
  config = {

    # Custom modules
    modules = { networking.tailscale.enable = true; };

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

        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/ZRV75mh7+1xiTR8+oNDabpUAmUrrEa6drrlhB4H2xqRoaBM5ZGlwuCgB+uTtsdcyM2sf0ZVep9vkjVFDbAAsoSeKM1sIySQXcPjaSFJX51aGUVWorPYfHIVljg6NHFKJtQFow/Kh3lzYs6F7ZbnrSGS25PWiR/ZfJx3RaGpCcyJcDUUjJ0Bt1+ORaayIL429IImEmW0/SqJL3PdzstkS8ukQ8rIki5MTU/Nk7RjbghkmzwONdMbu+8/fego7LbxJYhzdt97lwB0g0k5Z/cSE5Dic3pa2oLRinVyPjfgGyxZ8lugaTjmGB9HroqVfg/C+QWAxUwouX0SWHnCYhXvF xavgroleau@gmail.com"
        ];
      };

      users.root = {
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/ZRV75mh7+1xiTR8+oNDabpUAmUrrEa6drrlhB4H2xqRoaBM5ZGlwuCgB+uTtsdcyM2sf0ZVep9vkjVFDbAAsoSeKM1sIySQXcPjaSFJX51aGUVWorPYfHIVljg6NHFKJtQFow/Kh3lzYs6F7ZbnrSGS25PWiR/ZfJx3RaGpCcyJcDUUjJ0Bt1+ORaayIL429IImEmW0/SqJL3PdzstkS8ukQ8rIki5MTU/Nk7RjbghkmzwONdMbu+8/fego7LbxJYhzdt97lwB0g0k5Z/cSE5Dic3pa2oLRinVyPjfgGyxZ8lugaTjmGB9HroqVfg/C+QWAxUwouX0SWHnCYhXvF xavgroleau@gmail.com"
        ];
      };
    };
  };
}
