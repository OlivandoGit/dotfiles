{
    services.openvpn.servers = {
        fastvpn  = { 
            config = '' config /etc/nixos/secrets/fastVPN.ovpn ''; 

            autoStart = false;
            updateResolvConf = true;
        };
	outsideuk = {
	    config = '' config /etc/nixos/secrets/outsideuk.ovpn '';

            autoStart = false;
            updateResolvConf = true;
	};
    };
}
