# OlivandoGit's dotfiles repository
These configuration files can be used to setup a PC exactly the way that I want it to be setup by configuring many of my most frequently used programs.

## Installation and usage
This repo has been built with the use of [GNU Stow](https://www.gnu.org/software/stow/) in mind, but it is not a requirement.

Once the repo has been cloned/forked and cloned, you can simply run ```stow .``` in the root directory to create symlinks of all the dotfile directories in the repo, or ```stow <module-name>``` to stow a specific module from the repo.

Note: the nixos directory is set to be ignored by the stow command using the ".stow-local-ignore" file as this directory does not need to be symlinked to be used.

If you do not wish to use GNU Stow, then you could either: create your own symlinks using ```ln -s <sub-directory> <config-directory>``` where \<sub-directory\> is the directory where a modules config files are stored (ie hyprland/.config/hypr) and \<config-location\> is the location of config files on your system (ususally \${HOME}/.config); or simply move the files from each module to your home directory using ``` mv <module-name>/* ${HOME} ```. 

## Programs configured using this dotfiles repo

Below are any relevent links, commands and a brief introduction for each of the programs configured by my dotfiles repo (because yes, I am that forgetful)

### Flavours
Github: https://github.com/Misterio77/flavours
> \[Flavours\] Is a CLI program that both builds and manages Base16 schemes and templates.

Flavours is a useful program for changing colour schemes whenever you wish. It can make the initial setup of a program's configuration files a little more awkward, but is well worth the trade off if you like to switch colour schemes every once in a while and want all your programs to reflect same theme.

It uses the [base16](https://github.com/chriskempson/base16) framework for themes so it is very easy to find popular colour schemes, or to create your own as all it requires is 16 different hex values in the correct format.

Once setup, colour schemes can be changes as easily as ```flavours apply <colour-scheme>```

### Git
These are just the configuration files created using the ```git config --global ...``` command so that I dont have to set this up again on each machine I use.

### Hyprland
Website: https://hypr.land/
> Hyprland provides the latest Wayland features, dynamic tiling, all the eyecandy, powerful plugins and much more, while still being lightweight and responsive

Hyprland is an easy to configure tiling window manager that uses the modern [Wayland](https://wayland.freedesktop.org/) protocol instead of [X](https://www.x.org/wiki/).

Other programs from the Hyprland eco system are also configured in the same directory, nameley: Hyprlock for a usable lockscreen and Hyprpaper for setting desktop backgrounds.

### Kitty
Website: https://sw.kovidgoyal.net/kitty/
> The fast, feature-rich, GPU based terminal emulator

Exactly as it says on the Tin, it's a terminal emulator and the default for [Hyprland](https://hypr.land/). This program has more features than I could ever possibly need from my Terminal emulator, but is super easy to build a basic configuration for. I will probably come back to this config someday, looking for some unique/interesting features to add.

### Nixos
Website: https://nixos.org/
>  Declarative builds and deployments. Nix is a tool that takes a unique approach to package management and system configuration.

Nixos is my current Linux distribution of choice for my main PCs as I have a love for the declarative approach to system configuration - see my [Homelab terrafrom](https://github.com/OlivandoGit/Homelab/tree/master/terraform) repository if this interests you aswell

More information on the Nixos configuration can be found on the [README.md file in the nixos directory](/nixos/README.md)

### Rofi
Github: https://github.com/davatorium/rofi
> A window switcher, Application launcher and dmenu replacement.

I use Rofi as an application launcher and is bound to ```SUPER + Space``` in most of my configs. This really is so much more helpful than the Windows start menu.

### Waybar
Github: https://github.com/Alexays/Waybar
> Highly customizable Wayland bar for Sway and Wlroots based compositors.

I hate CSS but damn, this almost made it worth it to setup my bar exactly how I wanted it. Waybar came recommended directly from the [Hyprland](https://hypr.land/) wiki. I only wish that I could use real CSS variables instead of the GTK ones.

### Wireplumber
Docs: https://pipewire.pages.freedesktop.org/wireplumber/
> WirePlumber is a modular session / policy manager for PipeWire and a GObject-based high-level library that wraps PipeWire’s API, providing convenience for writing the daemon’s modules as well as external tools for managing PipeWire.

I mostly use wireplumber to disable HDMI audio outputs on my PCs so they stop auto-switching audio outputs whenever I turn the monitors on

### TODO
- [ ] Integrate rofi with flavours
- [ ] Add other favourite colourschemes to flavours config
- [ ] VSCode configuration (?)
