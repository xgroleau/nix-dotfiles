{ config, lib, pkgs, nixpkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # User config
  home.keyboard = {
    layout = "ca";
    options = [ "caps:swapescape" ];
  };
  home.language.base = "en_CA.UTF-8";

  targets.genericLinux.enable = true;
  systemd.user.startServices = "sd-switch";
  nixpkgs.config.allowUnfree = true;
  home.enableNixpkgsReleaseCheck = true;

  imports =
    [ ./modules/desktop ./modules/dev ./modules/shell ./modules/editors];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
