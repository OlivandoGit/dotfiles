{
    services.openvpn.servers = {
        fastVPN  = { 
            config = '' config /etc/nixos/secrets/fastVPN.ovpn ''; 

            autoStart = false;
            updateResolvConf = true;
        };
    };
}