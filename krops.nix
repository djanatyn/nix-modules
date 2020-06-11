let
  krops = builtins.fetchGit {
    url = "https://cgit.krebsco.de/krops/";
    ref = "v1.21.0";
    rev = "55aa2c77ce8183f3d2b24f54efa33ab6a42e1e02";
  };
  lib = import "${krops}/lib";
  pkgs = import "${krops}/pkgs" { };

  sources = {
    sahaquiel = lib.evalSource [{
      nixpkgs.git = {
        url = "https://github.com/nixos/nixpkgs";
        ref = "20.03";
      };
      nixos-config.file = toString ./sahaquiel.nix;
      modules.file = toString ./modules;

      secrets.pass = {
        dir = toString /var/secrets;
        name = "sahaquiel";
      };
    }];
  };
in {
  sahaquiel = pkgs.krops.writeDeploy "deploy-sahaquiel" {
    source = sources.sahaquiel;
    target = "root@sahaquiel.flowercluster.io";
  };
}
