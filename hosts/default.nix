{

  azura = {
    system = "x86_64-linux";
    cfg = import ./azura;
  };

  jyggalag = {
    system = "aarch64-linux";
    cfg = import ./jyggalag;
  };

  namira = {
    system = "x86_64-linux";
    cfg = import ./namira;
  };

  namira = {
    system = "x86_64-linux";
    cfg = import ./talos;
  };

}
