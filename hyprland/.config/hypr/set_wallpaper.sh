#!/usr/bin/env bash

current=$(hyprctl hyprpaper listloaded)

ln -s  $current $HOME/.config/hypr/.current_wallpaper
