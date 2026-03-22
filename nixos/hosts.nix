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

        # ==== Extra modules ====
        modules = ["nvidia" "bluetooth" "restic" "printing" "hyprland" "docker" "steam" "comfyui" "ollama" "ssh"];

        # ==== Modules with configurations ====
        configModules = {
            networking = {
                interfaces.enp4s0 = {
                    ipv4.addresses = [{ address = "192.168.1.86"; prefixLength = 24; }];
                };

                defaultGateway = {
                    address = "192.168.1.254";
                    interface = "enp4s0";
                };

                nameservers = [
                    "192.168.1.253"
                    "192.168.1.252"
                    "9.9.9.9"
                ];
            };

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
                openvpn = {
                    fastvpn = {
                        config = '' config /etc/nixos/secrets/openvpn/fastVPN.ovpn '';
                        autoStart = false;
                        updateResolvConf = false;
                    };
                    outsideuk = {
                        config = '' config /etc/nixos/secrets/openvpn/outsideuk.ovpn'';
                        autoStart = false;
                        updateResolvConf = false;
                    };
                };
                wireguard = [
                    "fastvpn"
                    "outsideuk"
                ];
            };
        };
        
    };
}
]
