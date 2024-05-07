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

  sheogorath = {
    system = "x86_64-linux";
    cfg = import ./sheogorath;
    deploy = {
      hostname = "sheogorath";
      sshUser = "root";
      user = "root";
    };
  };

  wsl = {
    system = "x86_64-linux";
    cfg = import ./wsl;
  };

}
