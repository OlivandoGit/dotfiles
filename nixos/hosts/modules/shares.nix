{ pkgs, hostSettings, ...  }:

let 
    nfsShares = (if builtins.hasAttr "nfs" hostSettings.shares then true else false);

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
    ) {} (if nfsShares then hostSettings.shares.nfs else []);
}