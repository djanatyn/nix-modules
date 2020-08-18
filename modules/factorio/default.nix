{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.voidheart.factorio;
  factorio = pkgs.factorio-headless-experimental.overrideAttrs (oldAttrs: rec {
    name = "factorio-${releaseType}-${version}";
    version = "1.0.0";
    releaseType = "headless";
    arch = "linux64";

    src = pkgs.fetchurl {
      name = "factorio-${releaseType}_${arch}-${version}.tar.xz";
      url =
        "https://www.factorio.com/get-download/${version}/${releaseType}/${arch}";
      sha256 = "0r0lplns8nxna2viv8qyx9mp4cckdvx6k20w2g2fwnj3jjmf3nc1";
    };
  });
in {
  options = { services.voidheart.factorio.enable = mkEnableOption "factorio"; };

  config = mkIf cfg.enable {
    services.factorio.enable = true;
    services.factorio.package = factorio;

    services.factorio.password =
      lib.fileContents /var/src/secrets/factorio/password;
  };
}
