{
    olivando = {       
        isNormalUser = true;

        extraGroups = ["wheel" "networkmanager" "docker" "comfyui"];
        
        uid = 1000;

        shell = "/home/olivando/.nix-profile/bin/bash";
    };
}
