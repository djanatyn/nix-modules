{ config, lib, pkgs, ... }:

let
  invocation = path:
    "/run/current-system/sw/bin/ritual /var/lib/nix-modules/${path}";
in {
  config = {
    users.users.srht-ci = {
      description = "srht user";
      shell = "/run/current-system/sw/bin/bash";
      createHome = false;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFQPTKrT397qtitl0hHkl3HysPfnpEm/WmO9f4dC4kLkrHIgs2t9Yvd6z+8C/hufW+e0cVug3sb6xHWFI78+/eCSRQpPWVsE3e6/U5R/EGJqylPLEa/SmB4hB6LpsCnJkeHnD/sVBz/EjFD29wifLFq0Y5keMdxbvUMjkGrep0CD1guYseFJOdFpLF3A5GAnnP2CHgvOT7/Pd2mym5f2Mxp17SF1iYAsx9xId5o6YbmKldz3BN51N+9CROSg9QWuSNCvA7qjflBIPtnBVZFvIN3U56OECZrv9ZY4dY2jrsUGvnGiyBkkdxw4+iR9g5kjx9jPnqZJGSEjWOYSl+2cEQGvvoSF8jPiH8yLEfC+CyFrb5FMbdXitiQz3r3Xy+oLhj8ULhnDdWZpRaJYTqhdS12R9RCoUQyP7tlyMawMxsiCUPH/wcaGInzpeSLZ5BSzVFhhMJ17TX+OpvIhWlmvpPuN0opmfaNGhVdBGFTNDfWt9jjs/OHm6RpVXacfeflP62xZQBUf3Hcat2JOqj182umjjZhBPDCJscfv52sdfkiqwWIc/GwdmKt5HqU+dX7lCFJ1OGF2ymnGEnkUwW+35qX8g2P+Vc4s28MmaO5M1R5UsMFnhtFbLdfLFKn2PEvepvIqyYFMziPzEBya4zBUch/9sd6UN3DV+rA/JB/rBApw== djanatyn@nixos"
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIOiCqSWnlyk3Efun+zeqeR9afQ3gwYV0QF2l9Us15F8BnNkEqZMvVYQipZUJKwyV4P8X7yJP+2G/KGVhW5kG+4= flowercluster"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVSmrwR4fBnc7+N6J4+8C9gCqRxwiTpYPtR1y2Rd/UggXYPxbM/fJNmz7n50w09J7B9yLnR8ghhwC0lmcIVlFC/g3wNDSBnDQO7xMj/jjp3sRY9Mn9D0099KY/oMd88v9q96L8iIYtH+R/eDyEdekH/MC3nj9WzKT5AhBTGEDXBPXy/V8CVOKK0xTWu5fMzLJ4v7gYYT5PQ1nJbY2NMb0rkwxt80LRxMjzdlApNH1j+efPuxzcA6ZUeprrKzD9o2j3PHmXxQCnRZVX8oSt3K4Fnvg1aFgurqob8NcK+lQ+46ntUuv5eY6+K3ab5ijJTyjiJblJ/n3BOielmTyFh4gm4GZ+L+AwBOBkV9SL8+wtKbR2UkYNz3gcDbHZ5by92qFkLNJvSyU0k/5Rb3GagarlZxsaLvxy9zK06umpkbYPhLKUKLs6EfO6nMVmSYHgP6ym7e38BO1HZB9c2pfwatKyXhIIwXca3InoX0zMrb+jqutBXBuhLW+mFwqLTo5HpmqolIjhPOJ1x2sptqDtXLZgxNbhQIEJgUjhEb7vs5BuVPdjLBFL2l4qeJxH+2dcGU5d731RJdF2LTtCMjnUyEmePq+y6ODAP/+fGUK+UsF0w7yJnL8IokJQu2G104hg9vtAOb7ayPZ4vR6MhRbjqZXsvYKroJc4QX1Ofet2uFnD2Q== srht-ci"
      ];
    };

    services.openssh.extraConfig = ''
      Match User srht-ci
        AllowAgentForwarding no
        AllowTcpForwarding no
        PermitTunnel no
        X11Forwarding no
        ForceCommand sudo ${invocation "voidheart-desktop/configuration.nix"}
      Match All
    '';

    security.sudo.extraRules = [{
      users = [ "srht-ci" ];
      commands = [
        {
          command = (invocation "vessel-vps/configuration.nix");
          options = [ "NOPASSWD" ];
        }
        {
          command = (invocation "voidheart-desktop/configuration.nix");
          options = [ "NOPASSWD" ];
        }
      ];
    }];
  };
}
