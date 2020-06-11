{ config, pkgs, ... }:

{
  environment.etc."consul-server.hcl".text = ''
    {
      "data_dir": "/var/lib/consul.d",
      "bind_addr": "{{ GetInterfaceIP \"eth0\" }}",
      "ui": true,
      "server": true
    }
  '';

  systemd.services.consul-server = {
    description = "consul server";

    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart =
        "${pkgs.consul}/bin/consul agent -config-file /etc/consul-server.hcl -bootstrap";
      Restart = "always";
      User = "root";
    };
  };
}
