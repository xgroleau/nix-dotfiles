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

  talos = {
    system = "x86_64-linux";
    cfg = import ./talos;
    deploy = {
      hostname = "talos";
      sshUser = "root";
      user = "root";
    };
  };

}
