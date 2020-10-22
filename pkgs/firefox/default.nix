{ stdenv, fetchurl, undmg }:
stdenv.mkDerivation rec {
  pname = "Firefox";
  version = "81.0.2";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Firefox.app "$out/Applications/Firefox.app"
  '';

  src = fetchurl {
    name = "Firefox-${version}.dmg";
    url =
      "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/en-US/Firefox%20${version}.dmg";
    sha256 = "1khzsnrk13z2lrwqd1vc6jm3qg7vmrgy996ss61ybfb6prjjj55s";
  };
}
