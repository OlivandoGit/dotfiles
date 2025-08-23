# My Nixos configuration
My configuration is built around the idea of having a centralised "control" file for the host settings and user settings - this files can be found in the root directory as "hosts.nix" and "users.nix" respectivly.

Using these files, I can change the common config items for each host/user without having to drill down into the module files to do so. The module files are then built in such a way that there is a default generic config incase no config options are provided. (ie incase I want one PC to use dhcp instead of static addressing)

Each user can also have multiple "profiles" which can be used to differentiate between host types and allow for different configs to be used depending on what type of system they are using (ie dont install Steam on a server)

## Installation and usage
I've never actually tried it this way, but theoretically something like this should work on a fresh NixOS install:\
Good luck \
```nix-shell -p git --command "nix run --experimental-features 'nix-command flakes' github:OlivandoGit/dotfiles/tree/master/nixos"```

### Creating a new host
1. Add the host into hosts.nix - [Read below for options](#Hostsnix)
2. Create a new directory under hosts with the hostname
3. Add configuration.nix and hardware-configuration.nix into the newly created directory

To build hosts: \
```sudo nixos-rebuild switch --flake .``` \
In the root directory of this repo

### Creating a new user
1. Add the user into users.nix - [Read below for options](#Usersnix)
2. Create a new diretory under users with the username
3. Create a new directory for each profile for the user and add configuration options

To build users: \
```home-manasger switch --flake .``` \
In the root directory of this repo

## Hosts.nix
Hosts.nix contains a list of attribute sets which each define a single host and its associated settings.

### Required hostSettings:
- ```system```        System architecture, ususally ```"x86_64-linux"```
- ```users```         A list of attribute sets, defining each user and their profile type on this host
- ```timezone```      Don't you want to know the correct time?
- ```locale```        Don't you want to be able to type?
- ```consoleKeymap``` Don't you want to be able to type on the console?

### Optional hostSettigs:
- ```networking```
    - ```ipv4``` Format: ```[ { interface [ { ipv4 CIDR } ] } ]``` \
    A list of attribute sets, each defining a single network interface and the ip address address(es) for that interface
    - ```defaultGateway``` Required if configuring static IP. Defines the default gateway address and the interface on which it can be reached 
    - ```dns``` A list of ip addresses for DNS servers. Optional extra when configuring with static IP

## Users.nix
Users.nix is used like a database to get user settings based on the username. The options in this file are the same as users.users.\<username\> on NisOS and is directly imported during system configuration. This way I can make sure that users have the same settings across all systems (espeically useful in the case of uid and nfs shares)

### TODO
- [ ] Add dns settings for non-static IP configuration
