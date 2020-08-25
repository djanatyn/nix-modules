{ config, lib, pkgs, ... }:
with lib;
let
  overlay = self: super: {
    terraria-server = super.terraria-server.overrideAttrs (old: rec {
      version = "1.4.0.5";

      src = pkgs.fetchurl {
        url =
          "https://terraria.org/system/dedicated_servers/archives/000/000/039/original/terraria-server-1405.zip";
        sha256 = "1bvcafpjxp7ddrbhm3z0xamgi71ymbi41dlx990daz0b5kbdir8y";
      };
    });
  };
in { config = { nixpkgs.overlays = [ overlay ]; }; }
