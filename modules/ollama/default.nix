{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.ollama;
in
{

  options.modules.ollama = with lib.types; {
    enable = lib.mkEnableOption "Ollama, an ai gpt, you know what it is";

    port = lib.mkOption {
      type = types.port;
      default = 11434;
      description = "The port to use";
    };

  };

  config =
    let
      homePath = "${cfg.dataDir}/home";
      modelsPath = "${cfg.dataDir}/models";
    in
    lib.mkIf cfg.enable {
      services.ollama = {
        enable = true;
        listenAddress = "0.0.0.0:${toString cfg.port}";
      };

    };
}
