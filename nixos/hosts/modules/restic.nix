{pkgs, ...}:

{
    environment.systemPackages = with pkgs; [
        restic
    ];

    users.users.restic = {
        isNormalUser = true;
        uid = 5000;
    };

    # security.polkit.enable = true;
    #     security.polkit.extraConfig = ''
    #     polkit.addRule(function(action, subject) {
    #         if (action.id == "org.freedesktop.login1.inhibit" &&
    #             subject.user == "restic") {
    #             return polkit.Result.YES;
    #         }
    #     });
    # '';

    security.wrappers.restic = {
        source = "${pkgs.restic.out}/bin/restic";
        owner = "restic";
        group = "users";
        permissions = "u=rwx,g=,o=";
        capabilities = "cap_dac_read_search=+ep";
    };

    services.restic = {

        backups = {
            localbackup = {
                initialize = true;
                
                user = "restic";
                package = pkgs.writeShellScriptBin "restic" ''exec /run/wrappers/bin/restic "$@"'';

                passwordFile = "/etc/nixos/secrets/restic";

                paths = [ "/home" ];
                exclude = [ 
                    "/home/*/.cache"
                    "/home/*/nas-storage"
                    
                    # Exclude everything in ssh except the config file
                    "/home/*/.ssh/*"
                    "!/home/*/config"
                ];

                # inhibitsSleep = true;

                repository = "/mnt/backups/restic";

                timerConfig = {
                    OnCalendar = "02:00";
                    Persistent = true;
                };

                pruneOpts = [
                    "--keep-daily 7"
                    "--keep-weekly 5"
                    "--keep-monthly 12"
                    "--keep-yearly 0"
                ];

                runCheck = true;
            };
        };
    };
}