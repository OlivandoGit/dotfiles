{
    # Enable cups
    services.printing.enable = true;

    # Network discorvery
    services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
    };

}