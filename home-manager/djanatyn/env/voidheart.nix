let checkout = "/home/djanatyn/repos/nix-modules";
in {
  imports = [ "${checkout}/home-manager/djanatyn" ];

  config.djanatyn = {
    email.mbsync.enable = true;
    gpg-agent.enable = true;
    music.enable = true;
  };
}
