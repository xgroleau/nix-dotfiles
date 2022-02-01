rec {
    minimal = {...}: {
          config.modules = {
            dev.common.enable = true;
            editors.nvim.enable = true;
            editors.emacs.enable = true;
            shell.tmux.enable = true;
            shell.zsh.enable = true;
        };
    };

    graphical = {...}: {
        config = {
            imports = [ minimal ];
            modules = {
                applications.firefox.enable = true;
                dev.cc.enable = true;
                dev.python.enable = true;
                editors.vscode.enable = true;
                shell.alacritty.enable = true;
            };
        };
    };

    desktop = {...}: {
        config = {
            imports = [ graphical ];
            modules = {
                desktop.active = "i3";
            };
        };
    };
}
