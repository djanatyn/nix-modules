{ config, lib, pkgs, ... }:
with lib;
let cfg = config.macos;
in {
  options = {
    macos.trustedUsers = mkOption { type = types.listOf types.str; };
  };

  config = {
    services = {
      nix-daemon.enable = true;
      yabai = {
        enable = true;
        package = pkgs.yabai;
        enableScriptingAddition = true;

        config = {
          focus_follows_mouse = "autoraise";
          mouse_follows_focus = "on";
          window_placement = "second_child";
          window_opacity = "on";
          window_border = "on";
          window_border_placement = "inset";
          window_border_width = 2;
          window_border_radius = 3;
          active_window_border_topmost = "off";
          window_topmost = "on";
          window_shadow = "float";
          layout = "bsp";
          auto_balance = "on";
          top_padding = 10;
          bottom_padding = 10;
          left_padding = 10;
          right_padding = 10;
          window_gap = 10;
        };
      };
    };

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
