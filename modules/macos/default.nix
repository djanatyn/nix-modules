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

      spacebar = {
        enable = true;
        package = pkgs.spacebar;
        config = {
          position = "top";
          background_color = "0xff202020";
          foreground_color = "0xffa8a8a8";
          space_icon_color = "0xff458588";
          power_icon_color = "0xffcd950c";
          battery_icon_color = "0xffd75f5f";
          space_icon_strip = lib.concatStringsSep " " [
            "one"
            "two"
            "three"
            "four"
            "five"
            "six"
            "seven"
            "eight"
            "nine"
            "ten"
          ];
          dnd_icon_color = "0xffa8a8a8";
          clock_icon_color = "0xffa8a8a8";
          clock_format = "%R";
          text_font = "FontAwesome";
        };
      };

      yabai = {
        enable = true;
        package = pkgs.yabai;
        enableScriptingAddition = true;

        config = {
          focus_follows_mouse = "off";
          mouse_follows_focus = "off";
          window_placement = "second_child";
          window_opacity = "on";
          window_shadow = "on";
          window_border = "on";
          window_border_placement = "inset";
          window_border_width = 2;
          active_window_border_color = "0x006dda74";
          normal_window_border_color = "0x00ff8c00";
          active_window_border_topmost = "off";
          window_topmost = "on";
          layout = "bsp";
          auto_balance = "on";
          top_padding = 36;
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
