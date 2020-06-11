{ config, lib, pkgs, ... }:
with lib;
let cfg = config.flowercluster.services.sourcehut;
in {
  options = {
    flowercluster.services.sourcehut.enable = mkEnableOption "sourcehut";
  };

  config = mkIf cfg.enable {
    environment.etc."sr.ht/config.ini".text = lib.generators.toINI { } {
      "sr.ht" = {
        site-name = "flowercluster.io";
        site-info = "http://src.flowercluster.io";
        environment = "development";
        site-blurb = "garden code and it will grow";

        owner-name = "Jonathan Strickland";
        owner-email = "djanatyn@gmail.com";

        source-url = "https://git.sr.ht/~sircmpwn/shrt";
        secret-key = lib.fileContents /var/src/secrets/sourcehut/secret-key;
      };

      webhooks = {
        private-key =
          lib.fileContents /var/src/secrets/sourcehut/webhooks/private-key;
      };

      "meta.sr.ht" = {
        origin = "http://src.flowercluster.io";
        debug-host = "0.0.0.0";
        debug-port = "5000";

        connection-string = "postgresql://sourcehut@localhost/meta.sr.ht";

        migrate-on-upgrade = "yes";
        welcome-emails = "no";
      };

      "meta.sr.ht::settings" = {
        registration = "no";
        onboarding-redirect = "http://src.flowercluster.io";
        user-invites = 5;
      };

      "meta.sr.ht::aliases" = { };

      "meta.sr.ht::billing" = { enabled = "no"; };
    };

    systemd.services.metasrht = {
      description = "meta.sr.ht";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${
            with pkgs;
            python3.withPackages (p: sourcehut.metasrht.propagatedBuildInputs)
          }/bin/python ${pkgs.sourcehut.metasrht.src}/run.py";
        Restart = "always";
        User = "root";
        WorkingDirectory = "${pkgs.sourcehut.metasrht.src}";
      };
    };

    environment.systemPackages = with pkgs; [
      sourcehut.gitsrht
      sourcehut.todosrht
      sourcehut.mansrht
      sourcehut.metasrht
      sourcehut.pastesrht
      sourcehut.dispatchsrht
      sourcehut.buildsrht
    ];
  };
}
