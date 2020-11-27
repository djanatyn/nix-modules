{ sources }:
let
  ritual = super:
    super.writeScriptBin "ritual" ''
      #!${super.stdenv.shell}

      nix-build '<nixpkgs/nixos>' -A system \
        -I nixpkgs=/var/lib/nixpkgs \
        -I modules=/var/lib/nix-modules/modules \
        -I nixos-config="$@" \
        --show-trace | cachix push djanatyn
    '';
in {
  macbook = self: super: { firefox = super.callPackage ./firefox { }; };

  vessel = self: super: {
    factorio = super.factorio-headless-experimental.overrideAttrs
      (oldAttrs: rec {
        name = "factorio-${releaseType}-${version}";
        version = "1.0.0";
        releaseType = "headless";
        arch = "linux64";

        src = super.fetchurl {
          name = "factorio-${releaseType}_${arch}-${version}.tar.xz";
          url =
            "https://www.factorio.com/get-download/${version}/${releaseType}/${arch}";
          sha256 = "0r0lplns8nxna2viv8qyx9mp4cckdvx6k20w2g2fwnj3jjmf3nc1";
        };
      });

    terraria-server = super.terraria-server.overrideAttrs (oldAttrs: rec {
      version = "1.4.0.5";

      src = super.fetchurl {
        url =
          "https://terraria.org/system/dedicated_servers/archives/000/000/039/original/terraria-server-1405.zip";
        sha256 = "1bvcafpjxp7ddrbhm3z0xamgi71ymbi41dlx990daz0b5kbdir8y";
      };
    });

    ritual = (ritual super);
  };

  voidheart = self: super:
    with super; {
      retroarch = retroarch.override {
        cores = [
          libretro.mupen64plus
          libretro.parallel-n64
          libretro.fceumm
          libretro.snes9x
          libretro.dolphin
          libretro.vba-m
          libretro.fbalpha2012
        ];
      };

      wine = wine.override { wineBuild = "wineWow"; };

      jackett = jackett.overrideAttrs (oldAttrs: rec {
        version = "0.16.1038";
        src = pkgs.fetchurl {
          url =
            "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.LinuxAMDx64.tar.gz";
          sha256 = "1mqizih40d76mbywgsh2w9wg2hwhqx1p0039bqlq3108cx2nqkb9";
        };
      });

      ritual = (ritual super);

      lutris = writeScriptBin "lutris" ''
        #!${stdenv.shell}

        export RADV_PERFTEST=aco
        exec ${lutris}/bin/lutris "$@"
      '';

      steam = writeScriptBin "steam" ''
        #!${stdenv.shell}

        export RADV_PERFTEST=aco
        exec ${steam}/bin/steam "$@"
      '';

      slippi = let slippi-niv = import sources.slippi { };
      in {
        playback = slippi-niv.playback;
        netplay = writeScriptBin "slippi-netplay" ''
          #!${stdenv.shell}

          exec ${slippi-niv.netplay}/bin/slippi-netplay \
            -u "''${HOME}/slippi-config" \
            "$@"
        '';
      };

    };
}
