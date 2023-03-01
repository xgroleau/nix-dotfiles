{ options, config, inputs, lib, pkgs, ... }:

{
  age = {
    secrets = {
      duckdns.file = ./duckdns.age;
      ghRunner.file = ./gh-runner.age;
    };
  };
}
