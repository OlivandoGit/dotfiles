{hostSettings, ...}:
{
    imports = [
        ./hardware-configuration.nix
        ./system-packages.nix

        ../modules

        ../modules/nvidia.nix
        ../modules/hyprland.nix

        ../modules/restic.nix

        ../modules/printing.nix
    ] ++ (if (builtins.hasAttr "shares" hostSettings) then [ ../modules/shares.nix ] else []);

    networking.hostName = "olivando-desktop";

    system.stateVersion = "25.05"; # DO NOT CHANGE
}


# if (builtins.hasAttr "dns" hostSettings.networking) then hostSettings.networking.dns else ["9.9.9.9" "8.8.8.8"];