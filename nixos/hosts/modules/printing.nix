{
    # Enable cups
    services.printing.enable = true;

    # Network discovery
    services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
    };

}