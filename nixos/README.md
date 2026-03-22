# My Nixos configuration
My configuration is built around the idea of having a centralised "control" file for the host settings and user settings - this files can be found in the root directory as "hosts.nix" and "users.nix" respectivly.

Using these files, I can change the common config items for each host/user without having to drill down into the module files to do so. The module files are then built in such a way that there is a default generic config in case no config options are provided. (ie in case I want one PC to use dhcp instead of static addressing)

Each user can also have multiple "profiles" which can be used to differentiate between host types and allow for different configs to be used depending on what type of system they are using (ie dont install Steam on a server)

## Installation and usage
I've never actually tried it this way, but theoretically something like this should work on a fresh NixOS install:\
Good luck \
```nix-shell -p git --command "nix run --experimental-features 'nix-command flakes' github:OlivandoGit/dotfiles/tree/master/nixos"```

### Creating a new host
1. Add the host into hosts.nix - [Read below for options](#Hostsnix)
2. Create a new directory under hosts with the hostname
3. Add Hardware-configuration.nix into the newly created directory

To build hosts: \
```sudo nixos-rebuild switch --flake .``` \
In the nixos directory of this repo

### Creating a new user
1. Add the user into users.nix - [Read below for options](#Usersnix)
2. Create a new directory under users with the username
3. Create a new directory for each profile for the user and add configuration options

To build users: \
```home-manager switch --flake .``` \
In the nixos directory of this repo

## Hosts.nix
Hosts.nix contains a list of attribute sets which each define a single host and its associated settings.

### Required hostSettings:
- ```system```        System architecture, usually ```"x86_64-linux"```
- ```users```         A list of attribute sets, defining each user and their profile type on this host
- ```timezone```      Don't you want to know the correct time?
- ```locale```        Don't you want to be able to type?
- ```consoleKeymap``` Don't you want to be able to type on the console?

### Optional hostSettigs:
- ```modules``` This is a list of configless modules to import from the modules directory

- ```configModules``` This is an attribute set of modules that allow for additional configuration options

    - ```networking``` This acts as a passthrough. The options available are the same as Nixos networking

    - ```shares```
        - ```nfs``` A list of attribute sets, each defining a single network share
            - ```mnt``` The directory to mount the nfs share to
            - ```address``` The address of the network share

    - ```vpns```
        - ```wireguard``` A list of wireguard config files stored in /etc/wireguard to be turned into systemd services

## Users.nix
Users.nix is used like a database to get user settings based on the username. The options in this file are the same as users.users.\<username\> on NisOS and is directly imported during system configuration. This way I can make sure that users have the same settings across all systems (especially useful in the case of uid and nfs shares)

### TODO
- [ ] Other network share types (smb)
- [ ] Add other vpn options (openvpn)