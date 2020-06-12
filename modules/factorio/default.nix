{ config, pkgs, lib, ... }:
with lib;
let cfg = config.flowercluster.services.factorio;
in {
  options = {
    flowercluster.services.factorio.enable = mkEnableOption "factorio";
  };

  config = mkIf cfg.enable {
    services.factorio.enable = true;
    services.factorio.package = pkgs.factorio-headless-experimental;

    services.factorio.password =
      lib.fileContents /var/src/secrets/factorio/password;
  };
}
