[
{
    hostname = "olivando-desktop";
    
    hostSettings = {
        # ==== Required ====
        users = [ {username = "olivando"; profile = "personal";} ];

        system = "x86_64-linux";
        timezone = "Europe/London";
        locale = "en_GB.UTF-8";
        consoleKeymap = "uk";

        networking = {
            ipv4 = [
            {
                interface = "enp4s0";
                addresses = [{ address =  "192.168.1.86"; prefixLength = 24; }];
            }
            ];

            defaultGateway = {
                address = "192.168.1.254";
                interface = "enp4s0";
            };

            dns = [
                "192.168.1.253"
                "192.168.1.252"
                "9.9.9.9"
            ];
        };

        # ==== Extra modules ====
        modules = ["nvidia" "bluetooth" "restic" "printing" "hyprland" "docker" "steam" "comfyui" "ollama"];

        # ==== Modules with configurations ====
        configModules = {
            shares = {
                nfs = [ 
                    {
                        mnt = "/mnt/nas-storage";
                        address = "truenas.home.olivando.me:/mnt/fast-storage/nas-storage";
                    }
                    {
                        mnt = "/mnt/backups";
                        address = "truenas.home.olivando.me:/mnt/fast-storage/backups";
                    }
                    {
                        mnt = "/mnt/docker-volumes";
                        address = "truenas.home.olivando.me:/mnt/fast-storage/docker-volumes";
                    }
                ];
            };

            vpns = {
                # openvpn = [
                #     {
                #         name = "fastvpn";
                #         config = '' config /etc/nixos/secrets/openvpn/fastVPN.ovpn '';
                #     }
                #     {
                #         name = "outsideuk";
                #         config = '' config /etc/nixos/secrets/openvpn/outsideuk.ovpn'';
                #     }
                # ];
                wireguard = [
                    "fastvpn"
                    "outsideuk"
                ];

            };
        };
        
    };
}
]
