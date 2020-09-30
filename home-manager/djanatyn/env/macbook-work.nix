let
  checkout = "/Users/stricklanj/repos/nix-modules";
  sources = import "${checkout}/nix/sources.nix" { };
  pkgs = import sources.nixpkgs { config = { allowUnfree = true; }; };
in {
  imports = [ "${checkout}/home-manager/djanatyn" ];

  config.djanatyn = {
    username = "stricklanj";
    email = {
      mbsync.enable = false;
      address = "stricklanj@ae.com";
    };

    gpg-agent.enable = false;
    music.enable = false;
  };
}
