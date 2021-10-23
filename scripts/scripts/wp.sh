#!/bin/sh

WP_DIR="$HOME/.dotfiles/wallpapers"
WP_FILES=($WP_DIR/*)

if [[ $# -eq 0 && -f "$HOME/.config/wallpaper" ]];
then
	xwallpaper --zoom "$HOME/.config/wallpaper"
elif [[ -f "${WP_FILES[0]}" ]];
then
	ln -sf "${WP_FILES[1]}" "$HOME/.config/wallpaper"
	xwallpaper --zoom $HOME/.config/wallpaper
fi
