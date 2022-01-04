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
  home.sessionVariables{IPYTHONDIR = "$XDG_CONFIG_HOME/ipython";
	PIP_CONFIG_FILE = "$XDG_CONFIG_HOME/pip/pip.conf";
	PIP_LOG_FILE = "$XDG_DATA_HOME/pip/log";
	PYLINTHOME = "$XDG_DATA_HOME/pylint";
	PYLINTRC = "$XDG_CONFIG_HOME/pylint/pylintrc";
	PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
	PYTHON_EGG_CACHE = "$XDG_CACHE_HOME/python-eggs";
	JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
  };
}
