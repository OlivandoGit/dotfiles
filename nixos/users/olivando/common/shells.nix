let
    myAliases = {
        "ll" = "ls -l";
        "lla" = "ls -la";
        ".." = "cd ..";
    };

in
    {
    programs = {
        bash = {
            enable = true;
            shellAliases = myAliases;
        };
        zsh = {
            enable = true;
            shellAliases = myAliases;
        };
};
}
