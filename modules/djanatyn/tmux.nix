let
  windows = rec {
    gitWindow = repo: {
      window_name = repo;
      start_directory = "~/repos/${repo}";
      panes = [ "git status" ];
    };

    cf-window = env: {
      window_name = env;
      start_directory = "~/repos/cf-automation";
      panes = [{
        shell_command =
          [ "source ./targets/${env}/ops-manager-credhub-bosh && bosh vms" ];
      }];
    };

    nix = [ (gitWindow "nixpkgs") (gitWindow "nix-modules") ];
    ansible =
      [ (gitWindow "ansible-inventory") (gitWindow "ansible-playbooks") ];
  };
in {
  ansible = {
    session_name = "ansible";
    windows = windows.ansible;
  };

  pivotal = {
    session_name = "pivotal";
    windows = [
      (windows.cf-window "control-plane")
      (windows.cf-window "sandbox")
      (windows.cf-window "nonprod")
      (windows.cf-window "production")
    ];
  };

  nix = {
    session_name = "nix";
    windows = builtins.concatLists [
      windows.nix
      [{
        window_name = "cordless";
        start_directory = "~/repos/cordless";
        panes =
          [{ shell_command = [ "/home/djanatyn/repos/cordless/cordless" ]; }];
      }]
    ];
  };
}
