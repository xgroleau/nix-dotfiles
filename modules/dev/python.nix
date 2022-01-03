{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    pythonFull
    pythonFullPackages.pip
    pythonFullPackages.ipython
    pythonFullPackages.black
    pythonFullPackages.setuptools
    pythonFullPackages.pylint
    pythonFullPackages.poetry
  ];
  env.IPYTHONDIR = "$XDG_CONFIG_HOME/ipython";
  env.PIP_CONFIG_FILE = "$XDG_CONFIG_HOME/pip/pip.conf";
  env.PIP_LOG_FILE = "$XDG_DATA_HOME/pip/log";
  env.PYLINTHOME = "$XDG_DATA_HOME/pylint";
  env.PYLINTRC = "$XDG_CONFIG_HOME/pylint/pylintrc";
  env.PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
  env.PYTHON_EGG_CACHE = "$XDG_CACHE_HOME/python-eggs";
  env.JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
}
