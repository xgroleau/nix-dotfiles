{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./emacs
    ./nvim
    ./vscode
  ];
}
