{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.flowercluster.services.factorio;
  factorio-latest = pkgs.factorio-headless-experimental.overrideAttrs
    (old: rec {
      version = "0.18.31";

      src = pkgs.fetchurl {
        name = "factorio_headless_linux64-0.18.31.tar.xz";
        url = "https://www.factorio.com/get-download/0.18.31/headless/linux64";
        sha256 = "17jslya538k910ppgfshzhxzbaxlf92ldbbcy1bhjyarmhwyk0i8";
      };
    });
in {
  options = {
    flowercluster.services.factorio.enable = mkEnableOption "factorio";
  };

  config = mkIf cfg.enable {
    services.factorio.enable = true;
    services.factorio.package = factorio-latest;

    services.factorio.password =
      lib.fileContents /var/src/secrets/factorio/password;
  };
}
