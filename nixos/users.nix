{
    olivando = {       
        isNormalUser = true;

        extraGroups = ["wheel" "networkmanager" "docker"];
        
        uid = 1000;

        shell = "/home/olivando/.nix-profile/bin/bash";
    };
}
