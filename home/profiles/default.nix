# Some modules for common presets for profile
rec {
  minimal = _: {
    config.modules = {
      dev.common.enable = true;
      editors.nvim.enable = true;
      nixpkgs.enable = true;
      shell.zellij.enable = true;
      shell.zsh.enable = true;
    };
  };

  dev = _: {
    imports = [ minimal ];
    config = {
      modules = {
        editors.emacs = {
          enable = true;
          defaultEditor = true;
        };

        dev = {
          cc.enable = true;
          python.enable = true;
          rust.enable = true;
        };
      };
    };
  };

  macos = { pkgs, ... }: {
    imports = [ dev ];
    config = {
      modules = {
        applications.discord.enable = true;
        shell.alacritty.enable = true;
      };

      home.packages = with pkgs; [ element-desktop spotify ];
    };
  };

  graphical = { pkgs, ... }: {
    imports = [ dev ];
    config = {
      modules = {
        applications.firefox.enable = true;
        applications.discord.enable = true;
        editors.vscode.enable = true;
        shell.alacritty.enable = true;
      };

      home.packages = with pkgs; [
        element-desktop
        beeper
        mattermost-desktop
        roam
        slack
        spotify
      ];
    };
  };

  desktop = _: {
    imports = [ graphical ];
    config = { modules = { desktop.active = "i3"; }; };
  };
}
