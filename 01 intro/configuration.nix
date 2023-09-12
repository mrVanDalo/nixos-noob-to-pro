{
  # parameter to reference configuration option values (see below)
  config
, # packages provided by the nix package manager
  pkgs
  # ignore all other given parameters
, ...
}:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Define a user account.
  users.users.alice = {
    isNormalUser = true; # Create home folder and give use a shell.
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh; # Use zsh instead of bash

    initialPassword = "change-me"; # Mutable password, run `passwd` once you logged in.

    # authorized to log in as user over ssh
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6uza62+Go9sBFs3XZE2OkugBv9PJ7Yv8ebCskE5WYPcahMZIKkQw+zkGI8EGzOPJhQEv2xk+XBf2VOzj0Fto4nh8X5+Llb1nM+YxQPk1SVlwbNAlhh24L1w2vKtBtMy277MF4EP+caGceYP6gki5+DzlPUSdFSAEFFWgN1WPkiyUii15Xi3QuCMR8F18dbwVUYbT11vwNhdiAXWphrQG+yPguALBGR+21JM6fffOln3BhoDUp2poVc5Qe2EBuUbRUV3/fOU4HwWVKZ7KCFvLZBSVFutXCj5HuNWJ5T3RuuxJSmY5lYuFZx9gD+n+DAEJt30iXWcaJlmUqQB5awcB1S2d9pJ141V4vjiCMKUJHIdspFrI23rFNYD9k2ZXDA8VOnQE33BzmgF9xOVh6qr4G0oEpsNqJoKybVTUeSyl4+ifzdQANouvySgLJV/pcqaxX1srSDIUlcM2vDMWAs3ryCa0aAlmAVZIHgRhh6wa+IXW8gIYt+5biPWUuihJ4zGBEwkyVXXf2xsecMWCAGPWPDL0/fBfY9krNfC5M2sqxey2ShFIq+R/wMdaI7yVjUCF2QIUNiIdFbJL6bDrDyHnEXJJN+rAo23jUoTZZRv7Jq3DB/A5H7a73VCcblZyUmwMSlpg3wos7pdw5Ctta3zQPoxoAKGS1uZ+yTeZbPMmdbw=="
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAhL8PEyWr2AEuumHUT97SqmpOtVnBExsPnttZJU9zkL"
    ];
  };

  # enable zsh + default configurations
  programs.zsh.enable = true;

  # List packages installed in system profile.
  # Only packages which are listed here will be installed => If you remove them the will be "uninstalled"
  # To search, run:
  # $ nix search <package-name>
  environment.systemPackages = [
    pkgs.vim
    pkgs.wget
  ];
  # we want vim as standard editor
  environment.variables.EDITOR = "vim";

  # Enable the OpenSSH daemon.
  # > if openssh is running port 22 will be opened automatically (this is a special behavior)
  services.openssh.enable = true;

  # install and provide a gitea server
  services.gitea.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    # open the http port of your gitea server.
    config.gitea.settings.server.HTTP_PORT
    # open the ssh port of your gitea server.
    config.gitea.settings.server.SSH_PORT
  ];
  networking.firewall.allowedUDPPorts = [ ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "23.05";

}

