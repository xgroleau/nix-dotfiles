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
    ];
    home.sessionVariables = {
      IPYTHONDIR = "$XDG_CONFIG_HOME/ipython";
      PIP_CONFIG_FILE = "$XDG_CONFIG_HOME/pip/pip.conf";
      PIP_LOG_FILE = "$XDG_DATA_HOME/pip/log";
      PYLINTHOME = "$XDG_DATA_HOME/pylint";
      PYLINTRC = "$XDG_CONFIG_HOME/pylint/pylintrc";
      PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
      PYTHON_EGG_CACHE = "$XDG_CACHE_HOME/python-eggs";
      JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
    };
  };
}
