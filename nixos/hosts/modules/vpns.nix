{ pkgs, hostSettings, lib,  ... }:

let 
    wireguard = (if builtins.hasAttr "wireguard" hostSettings.vpns then true else false);

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
        };
    };
in
{
    systemd.services = builtins.foldl' (
        v: vpn: v // {
            "wireguard-${vpn}" = makewireguard { inherit vpn; };
        }
    ) {} (if wireguard then hostSettings.vpns.wireguard else []);

    environment.systemPackages = [] ++ lib.optional wireguard pkgs.wireguard-tools;
}

