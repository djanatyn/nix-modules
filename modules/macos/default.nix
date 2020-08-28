{ config, lib, pkgs, ... }:
with lib;
let cfg = config.macos;
in {
  options = {
    macos.trustedUsers = mkOption { type = types.listOf types.str; };
  };

  config = {
    services = { nix-daemon.enable = true; };

    programs = {
      nix-index.enable = true;
      bash.enable = true;
      zsh.enable = true;
    };

    nix = {
      package = pkgs.nix;
      trustedBinaryCaches =
        [ "https://cache.nixos.org" "https://all-hies.cachix.org" ];
      inherit (cfg) trustedUsers;
    };

    # don't auto-fix homestuck typing quirks
    system.defaults = {
      NSGlobalDomain = {
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
      dock.autohide = true;
    };
  };
}
