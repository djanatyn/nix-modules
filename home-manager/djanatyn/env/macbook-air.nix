let
  checkout = "/Users/jonathanstrickland/repos/nix-modules";
  sources = import "${checkout}/nix/sources.nix" { };
  pkgs = import sources.nixpkgs { config = { allowUnfree = true; }; };
in {
  imports = [ "${checkout}/home-manager/djanatyn" ];

  config.djanatyn = {
    username = "jonathanstrickland";
    email = {
      mbsync.enable = false;
      address = "djanatyn@gmail.com";
    };

    gpg-agent.enable = false;
    music.enable = false;
  };
}
