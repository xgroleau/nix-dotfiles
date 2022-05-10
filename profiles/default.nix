# Some modules for common presets for profile
rec {
  minimal = _: {
    config.modules = {
      dev.common.enable = true;
      editors.nvim.enable = true;
      editors.emacs.enable = true;
      nixpkgs.enable = true;
      shell.tmux.enable = true;
      shell.zsh.enable = true;
    };
  };

  dev = _: {
    imports = [ minimal ];
    config = {
      modules = {
        dev.cc.enable = true;
        dev.python.enable = true;
        dev.rust.enable = true;
      };
    };
  };

  graphical = _: {
    imports = [ dev ];
    config = {
      modules = {
        applications.element.enable = true;
        applications.firefox.enable = true;
        applications.gitkraken.enable = true;
        applications.discord.enable = true;
        applications.spotify.enable = true;

        editors.vscode.enable = true;
        shell.alacritty.enable = true;
      };
    };
  };

  desktop = _: {
    imports = [ graphical ];
    config = { modules = { desktop.active = "i3"; }; };
  };
}
