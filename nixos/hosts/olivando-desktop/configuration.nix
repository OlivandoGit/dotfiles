{
    imports = [
        ./hardware-configuration.nix
        ./system-packages.nix

        ../modules

        ../modules/nvidia.nix
        ../modules/hyprland.nix
    ];

    networking.hostName = "olivando-desktop";

    system.stateVersion = "25.05"; # DO NOT CHANGE
}
