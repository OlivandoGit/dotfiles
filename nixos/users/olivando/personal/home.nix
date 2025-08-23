{ config, pkgs, ... }:
{
    imports = [
        ../common
        ../common/uwsm.nix
        ./modules
        ./packages.nix
    ];

    home.username = "olivando";
    home.homeDirectory = "/home/olivando";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    home.stateVersion = "25.05";
}
