# nix-modules
Shared NixOS + nix-darwin modules.

## Patterns
- Use niv for version pinning
- Use home-manager for dotfiles / user config
- Shared nixpkgs between all environments
- nixpkgs overlays for package overrides
- Uses krops for remote deployment
- Uses pass for secret management

## Interesting Features
- Slippi Melee netplay with matchmaking, replays, packaged udev gamecube rules
- Outlook Exchange inbox ingested into emacs using davmail + mbsync + notmuch
- Conditional MacOS configuration (only some dotfiles are deployed, only some
  attributes evaluated)
- Time-series system monitoring deployed on both cloud and desktop

## Managed Systems
### voidheart.nix
NixOS Desktop:
```text
$ neofetch
          ::::.    ':::::     ::::'
          ':::::    ':::::.  ::::'
            :::::     '::::.:::::
      .......:::::..... ::::::::
     ::::::::::::::::::. ::::::    ::::.
    ::::::::::::::::::::: :::::.  .::::'      djanatyn@voidheart
           .....           ::::' :::::'       ------------------
          :::::            '::' :::::'        OS: NixOS 20.09 (Nightingale) x86_64
 ........:::::               ' :::::::::::.   Host: B450M DS3H
:::::::::::::                 :::::::::::::   Kernel: 5.7.15
 ::::::::::: ..              :::::            Uptime: 4 days, 3 hours, 55 mins
     .::::: .:::            :::::             Packages: 2482 (nix-system), 1461 (nix-user), 3090 (nix-default)
    .:::::  :::::          '''''    .....     Shell: zsh 5.8
    :::::   ':::::.  ......:::::::::::::'     Resolution: 1920x1080, 1080x1920
     :::     ::::::. ':::::::::::::::::'      DE: none+xmonad
            .:::::::: '::::::::::             CPU: AMD Ryzen 5 3600 (12) @ 3.600GHz
           .::::''::::.     '::::.            GPU: AMD ATI 09:00.0 Device 731f
          .::::'   ::::.     '::::.           Memory: 10535MiB / 32130MiB
         .::::      ::::      '::::.
```

Runs:
- grafana + prometheus
- openvpn
- dnsmasq
- jackett
- jellyfin
- xmonad

To deploy:
``` text
$ sudo -E ritual switch
The lantern has been lit, and your summons heeded. A fine stage
you chose, this kingdom fallowed by worm and root, perfect earth upon
which our Ritual shall take place.

unpacking 'https://github.com/rycee/home-manager/archive/6cf6b587b575493e7718bf08b209013d7dcf4d58.tar.gz'...
...
```

### work.nix
Work MacBook.

Mostly manages system configuration and package installs.

There is some extra configuration for downloading mail from Microsoft Exchange WebMail. The notmuch email indexer is installed, and emacs configuration is included.

### air.nix
Personal MacBook Air.

Shares configuration with work.nix through `modules/macos`.

### vessel.nix
OVHCloud VPS. Much cheaper than AWS / GCP! NixOS made it easy to migrate between three different cloud providers.

To deploy:
``` text
 $(nix-build ./krops.nix -A vessel -o deploy)
+ /nix/store/mn2bcxk1vb8npg6mlkxvfy9gmjh7lsz5-populate.vessel.voidheart.io.modules
...
```
