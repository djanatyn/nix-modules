{ config, ... }:
let
  overlay = self: super:
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

      ritual = writeScriptBin "ritual" ''
        #!${stdenv.shell}
        cat <<EOF
        The lantern has been lit, and your summons heeded. A fine stage
        you chose, this kingdom fallowed by worm and root, perfect earth upon
        which our Ritual shall take place.

        EOF

        exec nixos-rebuild \
          -I "nixos-config=''${HOME}/repos/nix-modules/voidheart.nix" \
          "$@"
      '';

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

  sources = import ./niv/sources.nix { };

  pkgs = import sources.nixpkgs {
    overlays = [ overlay (import sources.nixpkgs-mozilla) ];
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        # required for lutris package
        "p7zip-16.02"
      ];
    };
  };
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    (import "${sources.home-manager}/nixos")
    ./modules/djanatyn
    ./modules/pri
    ./modules/monitoring
  ];

  # (don't update unless you know what you're doing)
  system.stateVersion = "19.09";

  # locale
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/New_York";

  # voidheart-specific user config
  djanatyn.enableGpgAgent = true;
  users = {
    users = {
      pripripripripri.openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBAZHvtrWNro8nsB5uyat5kpzdwZ1pArC+LvKap2/eNSQJ8TPuMhvvxNru4nEsX9HdMGQX3vVnjflcCuR5oHp/kcNw4IsmQ14OnOc7k3NsY0NnTjaIeL530Vt1ooaddyDJI2pVXx4Fhr8V99wc7Mixu8VdQHPXqIElOC6cSz0/1BTiEB+5wDYidqS4W2YrVyirIMVvdIaKZg8GM953u+QDXhp2J/srLXJyLzHJ0VR/0lbKZiBHvzi8CH/nP1cyFTAvn2yMrMQZqWnGDefWHI3Mq9wnn+J+6WObk9dr0C7a/hZpjfRKUPEOnHBT8bEjadiv+oFgQzNCH9ffJka3XGnZQ7RqcAD2z/dtoXm2kBhOyET5gG2P+1/alHjRzkBW9Zc/X8mxSSj7crXZ4umH+yCw0WXdDi2Swldx7IbuxUc7AeyayaBLN3RfLGHy0H1zHsv8ZPY5NaBNbG9zi3X7y4s+wsqOqdpnI/C5VS1W1KA/j01Z2KVi8OAdtrZSLJ37FO0= prd17@Dbmis-MBP-2"
      ];
      djanatyn = {
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFQPTKrT397qtitl0hHkl3HysPfnpEm/WmO9f4dC4kLkrHIgs2t9Yvd6z+8C/hufW+e0cVug3sb6xHWFI78+/eCSRQpPWVsE3e6/U5R/EGJqylPLEa/SmB4hB6LpsCnJkeHnD/sVBz/EjFD29wifLFq0Y5keMdxbvUMjkGrep0CD1guYseFJOdFpLF3A5GAnnP2CHgvOT7/Pd2mym5f2Mxp17SF1iYAsx9xId5o6YbmKldz3BN51N+9CROSg9QWuSNCvA7qjflBIPtnBVZFvIN3U56OECZrv9ZY4dY2jrsUGvnGiyBkkdxw4+iR9g5kjx9jPnqZJGSEjWOYSl+2cEQGvvoSF8jPiH8yLEfC+CyFrb5FMbdXitiQz3r3Xy+oLhj8ULhnDdWZpRaJYTqhdS12R9RCoUQyP7tlyMawMxsiCUPH/wcaGInzpeSLZ5BSzVFhhMJ17TX+OpvIhWlmvpPuN0opmfaNGhVdBGFTNDfWt9jjs/OHm6RpVXacfeflP62xZQBUf3Hcat2JOqj182umjjZhBPDCJscfv52sdfkiqwWIc/GwdmKt5HqU+dX7lCFJ1OGF2ymnGEnkUwW+35qX8g2P+Vc4s28MmaO5M1R5UsMFnhtFbLdfLFKn2PEvepvIqyYFMziPzEBya4zBUch/9sd6UN3DV+rA/JB/rBApw== djanatyn@nixos"
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIOiCqSWnlyk3Efun+zeqeR9afQ3gwYV0QF2l9Us15F8BnNkEqZMvVYQipZUJKwyV4P8X7yJP+2G/KGVhW5kG+4= flowercluster"
        ];
        extraGroups = [ "adb" ];
      };
    };

    extraGroups.vboxusers.members = [ "djanatyn" ];
  };

  nix = {
    useSandbox = true;
    optimise.automatic = true;
    gc.automatic = true;
    package = pkgs.nix;
  };

  boot = with pkgs; {
    loader = {
      grub = {
        enable = true;
        version = 2;
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
      };
      efi.efiSysMountPoint = "/boot";
      systemd-boot.enable = true;
    };

    kernelPackages = linuxPackages_latest;
    kernelModules = [ "kvm-amd" "kvm" ];
    extraModulePackages = [ linuxPackages_latest.v4l2loopback ];
    kernelParams = [
      "amdgpu.noretry=0"
      "amdgpu.gpu_recovery=1"
      "amdgpu.lockup_timeout=1000"
      "amdgpu.gttsize=8192"
      "amdgpu.ppfeaturemask=0xfffd3fff"
    ];

    initrd.luks.devices = {
      root = {
        device = "/dev/nvme0n1p2";
        preLVM = true;
      };
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  hardware = {
    enableRedistributableFirmware = true;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };

    pulseaudio = {
      enable = true;
      support32Bit = true;
      configFile = pkgs.runCommand "default.pa" { } ''
        sed 's/module-udev-detect$/module-udev-detect tsched=0/' \
          ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
      '';
    };
  };

  systemd = {
    coredump.enable = true;
    globalEnvironment = { RADV_PERFTEST = "aco"; };
  };

  networking = {
    hostName = "voidheart";
    useDHCP = false;
    interfaces.enp5s0.useDHCP = true;
  };

  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
    virtualbox.host.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];

      layout = "us";
      xkbOptions = "ctrl:nocaps";

      displayManager.defaultSession = "none+xmonad";
      desktopManager.xterm.enable = false;
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };

    openvpn.servers = {
      expressvpn = { config = "config /root/nixos/openvpn/expressvpn.conf"; };
    };

    udev.extraRules = ''
      # gamecube wii u usb adapter
      ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="666", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device" TAG+="uaccess"
    '';

    openssh.enable = true;
    lorri.enable = true;
    flowercluster.monitoring.enable = true;
  };

  security = {
    sudo.wheelNeedsPassword = false;
    pam.enableSSHAgentAuth = true;
  };

  programs = {
    adb.enable = true;
    browserpass.enable = true;
    mtr.enable = true;
    sysdig.enable = true;
    bandwhich.enable = true;
  };

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  environment.systemPackages = with pkgs; [

    # browser
    latest.firefox-nightly-bin
    chromium

    # nix
    ritual
    nix-prefetch-scripts
    nixfmt
    nox
    patchelf

    # system
    rsync
    which
    file
    dnsutils
    whois
    binutils

    # terminal
    rxvt_unicode
    terminus_font
    terminus_font_ttf

    # shell
    nushell
    zsh
    exa
    procs
    tmux
    tmuxp
    htop
    ytop
    bat
    fzy

    # network
    mtr
    rtorrent
    networkmanagerapplet

    # virtualisation
    qemu_kvm

    # java
    openjdk11

    # archives
    unzip
    unrar

    # utilities
    xclip
    aspell

    # hashicorp
    terraform
    packer
    nomad

    # ansible
    ansible
    ansible-lint

    # chat
    discord
    spectral

    # media
    mpv
    spotify
    pavucontrol
    pulsemixer

    # editor
    emacs
    vim

    # searching
    ripgrep
    fd
    sd
    silver-searcher

    # filesystem
    du-dust
    broot

    # development
    direnv
    gdb
    git
    gist
    git-lfs
    gitAndTools.git-annex
    gitAndTools.git-annex-utils
    gitAndTools.pre-commit
    gitAndTools.diff-so-fancy
    google-cloud-sdk
    cloc
    tokei
    hyperfine

    # haskell
    stack
    ormolu

    # secrets
    gnupg
    diceware
    pass
    sshpass
    keybase

    # ssh
    assh
    sshuttle

    # games
    xonotic
    flips
    runelite
    retroarch
    sgtpuzzles
    multimc
    eidolon

    # overlay packages
    steam
    lutris
    slippi.playback
    slippi.netplay

    # streaming
    obs-studio
    screenkey

    # window management
    nitrogen
    arandr
    xmobar
    compton
    maim
    xscreensaver
    rofi
    wmctrl
  ];
}
