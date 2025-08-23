{username, profile, ...}:
{
    imports = [
        # IDE hates the below, but they work
        ./${username}/common
        ./${username}/${profile}
    ];

    home.username = username;
    home.homeDirectory = "/home/${username}";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    home.stateVersion = "25.05";
}
