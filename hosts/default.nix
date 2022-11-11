{
  godzilla = {
    system = "x86_64-linux";
    cfg = import ./godzilla;
  };

  mothra = {
    system = "x86_64-linux";
    cfg = import ./mothra;
  };

  rodan = {
    system = "aarch64-linux";
    cfg = import ./rodan;
  };
}
