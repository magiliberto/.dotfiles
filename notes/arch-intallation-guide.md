# Graphical enviroment
paru -S python-pywlroots


XKB_DEFAULT_LAYOUT=latam qtile start -b wayland
GTK_THEME=Adwaita:dark brave --enable-features=UseOzonePlatform --ozone-platform=wayland

paru -S insync keepassxc


# Audio
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack

