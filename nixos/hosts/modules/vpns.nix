{ pkgs, hostSettings, lib,  ... }:

let 
    wireguard = hostSettings.configModules.vpns ? wireguard;
    openvpn = hostSettings.configModules.vpns ? openvpn;

    makewireguard = {vpn}: {
        description = "Manual WireGuard VPN (${vpn})";
        wantedBy = [ ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];

        serviceConfig = {
            Type = "simple";
            ExecStart = "/run/current-system/sw/bin/wg-quick up ${vpn}";
            ExecStop = "/run/current-system/sw/bin/wg-quick down ${vpn}";
            RemainAfterExit = true;

            Restart= "on-failure";
            RestartSec = 5;
        };
    };

    makeOpenvpn = {config}: {
        inherit config;
        autoStart = false;
        updateResolvConf = false;
    };
in
{
    systemd.services = builtins.foldl' (
        v: vpn: v // {
            "wireguard-${vpn}" = makewireguard { inherit vpn; };
        }
    ) {} (if wireguard then hostSettings.configModules.vpns.wireguard else []);

    environment.systemPackages = [] ++ lib.optional wireguard pkgs.wireguard-tools;

    services.openvpn.servers = builtins.foldl' (
        v: vpn: v // {
            ${vpn.name} = makeOpenvpn { inherit (vpn) config; };
        }
    ) {} (if openvpn then hostSettings.configModules.vpns.openvpn else []);
}

