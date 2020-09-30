let
  checkout = "/home/djanatyn/repos/nix-modules";
  sources = import "${checkout}/nix/sources.nix" { };
  pkgs = import sources.nixpkgs { config = { allowUnfree = true; }; };
in {
  imports = [ "${checkout}/home-manager/djanatyn" ];

  config.djanatyn = {
    email.mbsync.enable = true;
    gpg-agent.enable = true;
    music.enable = true;
  };
}
