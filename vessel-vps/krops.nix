let
  krops = builtins.fetchGit {
    url = "https://cgit.krebsco.de/krops/";
    ref = "v1.21.0";
    rev = "55aa2c77ce8183f3d2b24f54efa33ab6a42e1e02";
  };
  lib = import "${krops}/lib";
  pkgs = import "${krops}/pkgs" { };

  sources = {
    vessel = lib.evalSource [{
      nixos-config.file = toString ./configuration.nix;
      modules.file = toString ../modules;
      home-manager.file = toString ../home-manager;
      pkgs.file = toString ../pkgs;
      nix.file = toString ../nix;

      secrets.pass = {
        dir = toString /var/secrets;
        name = "vessel";
      };
    }];
  };
in {
  vessel = pkgs.krops.writeDeploy "deploy-vessel" {
    source = sources.vessel;
    target = "root@vessel.voidheart.io:8888";
  };
}
