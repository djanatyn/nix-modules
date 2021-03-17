{
  imports = [ /home/djanatyn/repos/nix-modules/home-manager/djanatyn ];

  config.djanatyn = {
    email.mbsync.enable = true;
    gpg-agent.enable = true;
    music.enable = true;
  };
}
