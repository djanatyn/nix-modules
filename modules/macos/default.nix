{ config, lib, pkgs, ... }:
with lib;
let cfg = config.macos;
in {
  options = { macos.username = mkOption { type = types.str; }; };

  config = {
    # setup nix-darwin for bash + zsh
    programs.zsh.enable = true;
    programs.bash.enable = true;

    # use nix-daemon on macos
    services.nix-daemon.enable = true;
    nix.package = pkgs.nix;
    nix.trustedBinaryCaches =
      [ "https://cache.nixos.org" "https://all-hies.cachix.org" ];
    nix.trustedUsers = [ cfg.username ];

    # don't auto-fix homestuck typing quirks
    system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
    system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
    system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
    system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
    system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;

    # autohide dock
    system.defaults.dock.autohide = true;
  };
}
