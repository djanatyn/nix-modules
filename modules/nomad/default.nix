{ config, pkgs, ... }: {
  environment.etc."nomad-server.hcl".text = ''
    data_dir = "/var/lib/nomad.d"
    datacenter = "dc1"
    ports {
      http = 4646
    }

    server {
      enabled = true
      bootstrap_expect = 1
    }
  '';

  environment.etc."nomad-client.hcl".text = ''
    data_dir  = "/var/lib/nomad.d"
    datacenter = "dc1"
    ports {
      http = 4747
    }

    client {
      enabled = true
    }
  '';

  systemd.services.nomad-server = {
    description = "Hashicorp Nomad Server";

    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "consul.service" ];

    serviceConfig = {
      ExecStart = "${pkgs.nomad}/bin/nomad agent -config /etc/nomad-server.hcl";
      Restart = "always";
      User = "root";
    };
  };

  systemd.services.nomad-client = {
    description = "Hashicorp Nomad Client";
    path = [ pkgs.iproute ];

    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "nomad-server.service" ];

    serviceConfig = {
      ExecStart = "${pkgs.nomad}/bin/nomad agent -config /etc/nomad-client.hcl";
      Restart = "always";
      User = "root";
    };
  };
}
