let
    myAliases = {
        "ll" = "ls -l";
        "lla" = "ls -la";
        ".." = "cd ..";
    };

    initExtras = ''
        # Start UWSM
        if uwsm check may-start; then
        exec uwsm start hyprland-uwsm.desktop
        fi
    '';
in
    {
    programs = {
        bash = {
        enable = true;
        shellAliases = myAliases;
        initExtra = initExtras;
        };
        zsh = {
        enable = true;
        shellAliases = myAliases;
        initContent = initExtras;
        };
};
}
