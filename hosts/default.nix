{
  namira = {
    system = "x86_64-linux";
    cfg = import ./namira;
  };

  azura = {
    system = "x86_64-linux";
    cfg = import ./azura;
  };

  jyggalag = {
    system = "aarch64-linux";
    cfg = import ./jyggalag;
  };
}
