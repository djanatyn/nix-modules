{ config, lib, pkgs, ... }:
with lib;
let cfg = config.djanatyn;
in {
  options = {
    djanatyn.groups = mkOption { type = types.listOf types.str; };
    djanatyn.username = mkOption { type = types.str; };
  };

  config = {
    users.users.djanatyn = {
      name = "Jonathan Strickland";
      isNormalUser = true;
      extraGroups = cfg.groups;
      shell = pkgs.zsh;

      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFQPTKrT397qtitl0hHkl3HysPfnpEm/WmO9f4dC4kLkrHIgs2t9Yvd6z+8C/hufW+e0cVug3sb6xHWFI78+/eCSRQpPWVsE3e6/U5R/EGJqylPLEa/SmB4hB6LpsCnJkeHnD/sVBz/EjFD29wifLFq0Y5keMdxbvUMjkGrep0CD1guYseFJOdFpLF3A5GAnnP2CHgvOT7/Pd2mym5f2Mxp17SF1iYAsx9xId5o6YbmKldz3BN51N+9CROSg9QWuSNCvA7qjflBIPtnBVZFvIN3U56OECZrv9ZY4dY2jrsUGvnGiyBkkdxw4+iR9g5kjx9jPnqZJGSEjWOYSl+2cEQGvvoSF8jPiH8yLEfC+CyFrb5FMbdXitiQz3r3Xy+oLhj8ULhnDdWZpRaJYTqhdS12R9RCoUQyP7tlyMawMxsiCUPH/wcaGInzpeSLZ5BSzVFhhMJ17TX+OpvIhWlmvpPuN0opmfaNGhVdBGFTNDfWt9jjs/OHm6RpVXacfeflP62xZQBUf3Hcat2JOqj182umjjZhBPDCJscfv52sdfkiqwWIc/GwdmKt5HqU+dX7lCFJ1OGF2ymnGEnkUwW+35qX8g2P+Vc4s28MmaO5M1R5UsMFnhtFbLdfLFKn2PEvepvIqyYFMziPzEBya4zBUch/9sd6UN3DV+rA/JB/rBApw== djanatyn@nixos"
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIOiCqSWnlyk3Efun+zeqeR9afQ3gwYV0QF2l9Us15F8BnNkEqZMvVYQipZUJKwyV4P8X7yJP+2G/KGVhW5kG+4= flowercluster"
      ];
    };

    home-manager.users.djanatyn = {
      programs.git = {
        enable = true;
        userName = "djanatyn";
        userEmail = "djanatyn@gmail.com";
      };
    };
  };
}
