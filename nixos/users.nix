{
    olivando = {       
        isNormalUser = true;

        extraGroups = ["wheel" "networkmanager"];
        
        uid = 1000;

        shell = "/home/olivando/.nix-profile/bin/bash";
    };
}
