{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.dev.python;
in {

  options.modules.dev.python = with types; {
    enable = mkBoolOpt false;
    package = mkOpt package pkgs.python38;
    pythonPackages = mkOpt attrs pkgs.python38Packages;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cfg.package
      cfg.pythonPackages.pip
      cfg.pythonPackages.black
      cfg.pythonPackages.setuptools
      cfg.pythonPackages.pylint
      cfg.pythonPackages.poetry
      cfg.pythonPackages.pipx
      # python-language-server
    ];
    home.sessionVariables = {
      IPYTHONDIR = "${config.xdg.configHome}/ipython";
      PIP_CONFIG_FILE = "${config.xdg.configHome}/pip/pip.conf";
      PIP_LOG_FILE = "${config.xdg.dataHome}/pip/log";
      PYLINTHOME = "${config.xdg.dataHome}/pylint";
      PYLINTRC = "${config.xdg.configHome}/pylint/pylintrc";
      PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonrc";
      PYTHON_EGG_CACHE = "${config.xdg.cacheHome}/python-eggs";
      JUPYTER_CONFIG_DIR = "${config.xdg.configHome}/jupyter";
    };
  };
}
