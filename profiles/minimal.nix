{ config , ...}:

# Module includes bare minimum. Only TUI applications
{
  config.modules = {
    dev.common.enable = true;
    editors.nvim.enable = true;
    editors.emacs.enable = true;
    shell.tmux.enable = true;
    shell.zsh.enable = true;
  };
}
