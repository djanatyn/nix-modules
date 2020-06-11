{ config, lib, pkgs, ... }:
with lib;
let
  overlay = self: super: {
    terraria-server = super.terraria-server.overrideAttrs (old: rec {
      version = "1.4.0.4";

      src = pkgs.fetchurl {
        url =
          "https://terraria.org/system/dedicated_servers/archives/000/000/038/original/terraria-server-1404.zip";
        sha256 = "09zkadjd04gbx1yvwpqmm89viydwxqgixbqhbqncb94qb2z5gfxk";
      };
    });
  };
in {
  config = { nixpkgs.overlays = [ overlay ]; };
}
