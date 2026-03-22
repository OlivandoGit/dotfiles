{ pkgs, hostSettings, ...  }:

let 
    nfsShares = hostSettings.configModules.shares ? nfs;

    makeShare = {address, type}: {
        device = "${address}";
        fsType = "${type}";
        options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
    };
in
{

    boot.supportedFilesystems = (if nfsShares then [ "nfs" ] else []);

    fileSystems = builtins.foldl' (
        shr: share: shr // {
            "${share.mnt}" = makeShare { inherit (share) address; type = "nfs"; };
        }
    ) {} (if nfsShares then hostSettings.configModules.shares.nfs else []);
}