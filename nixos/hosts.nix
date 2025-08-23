[
{
    hostname = "olivando-desktop";
    
    hostSettings = {
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
    };
}
]
