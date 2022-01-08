#!/bin/sh

cd .dotfiles
git pull
stow --adopt -Svt ~ scripts/ wallpapers/
cd


git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
bash

base16_solarized-dark
sudo pacman -S xorg-server xorg-apps xorg-init libxkbcommon xterm alacritty qtile keepassxc network-manager-applet firefox xwallpaper lxsession pulseaudio volumeicon 
paru -S nerd-fonts-source-code-pro insync brave

localctl --no-convert set-x11-keymap latam

# Get defalult configs for xinit and qtile
# cp /etc/X11/xinit/xinitrc ~/.xinitrc
# replace last lines

# $HOME/scripts/wp.sh &
# lxsession &
# insync start &
# keepassxc &
# nm-applet &
# volumeicon &
# exec qtile start

# mkdir -p ~/.config/qtile/
# cp /usr/share/doc/qtile/default_config.py ~/.config/qtile/config.py
