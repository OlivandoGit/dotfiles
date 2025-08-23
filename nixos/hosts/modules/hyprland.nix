{
    programs.hyprland = {
        enable = true;

        withUWSM = true;

        xwayland.enable = true;
    };

    security.pam.services.hyprlock = { };

    environment.sessionVariables = {
        # Configures Electron / CEF apps to use Wayland
        NIXOS_OZONE_WL = "1";
    };
}
