# Installation guide 

## Pre installation

Download ISO file
```bash
dd bs=4M if=<path/to/iso_file.iso> of=/dev/sdb status=progress oflag=sync
```
## Base installation

Set keyboard layout 
```bash
# ls /usr/share/kbd/keymaps/**/*.map.gz # Get all available keymaps
loadkeys la-latin1 # Set latin keymaps
```

SSH connection (for remote installation)
```bash
pacman -Syy openssh
systemctl start sshd
passwd
ip a # get <ip>
ssh root@<ip> # On remote machine
```

Set time-clock 
```bash
timedatectl set-ntp true
```

### Partition disk (gdisk)

```bash
lsblk
gdisk /dev/sda
```

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048         1050623   512.0 MiB   EF00  EFI system partition
   2         1050624        34605055   16.0 GiB    8200  Linux swap
   3        34605056       244320255   100.0 GiB   8304  Linux x86-64 root (/)
   4       244320256       936380415   330.0 GiB   8312  Linux user's home

gdisk commands:

o - Create GPT partition table
n - Add partition
p - Print partition table
w - Write partition table

### Format partitions

```bash
mkfs.vfat /dev/sda1 # Boot
mkswap /dev/sda2 # Swap
swapon /dev/sda2
mkfs.btrfs -f /dev/sda3 # Root
mkfs.ext4 /dev/sda4 # Home
```

### Create sub-volumes & mount 
source: https://wiki.archlinux.org/title/Snapper#Suggested_filesystem_layout

```bash
mount /dev/sda3 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@var_log
btrfs su cr /mnt/@.snapshots
umount /mnt
mount -o noatime,compress=lzo,space_cache,discard=async,subvol=@ /dev/sda3 /mnt
mkdir -p /mnt/{efi,var/log,.snapshots}
mount -o noatime,compress=lzo,space_cache,discard=async,subvol=@var_log /dev/sda3 /mnt/var/log
mount -o noatime,compress=lzo,space_cache,discard=async,subvol=@.snapshots /dev/sda3 /mnt/.snapshots
```

### Install essencial packages
```bash
pacstrap /mnt base base-devel linux linux-firmware linux-headers intel-ucode man-db man-pages tmux ranger neofetch htop neovim btrfs-progs snapper git python-pip stow ntfs-3g networkmanager openssh
```

### Arch chroot
```bash
arch-chroot /mnt # change root into new system
```

### Enable services
```bash
systemctl enable NetworkManager 
systemctl enable sshd
```

### Add user
```bash
useradd -m mg
su mg
mkdir /home/mg/gdrive
exit
exit
```

### Mount & genfstab
```bash
mount /dev/sda1 /mnt/efi
mount /dev/sda4 /mnt/home/mg/gdrive
genfstab -U /mnt >> /mnt/etc/fstab # Generate mount instructions
```

### Configurate base system

```bash
arch-chroot /mnt # change root into new system
```

Set timezone
```bash
ln -sf /usr/share/zoneinfo/America/Buenos_Aires /etc/localtime
hwclock --systohc # to generate /etc/adjtime
```

Localization
```bash
nvim /etc/locale.gen # uncomment en_US.UTF-8
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=la-latin1" >> /etc/vconsole.conf
```

Network configuration
```bash
echo arch >> /etc/hostname
nvim /etc/hosts
```

127.0.0.1	localhost
::1		localhost
127.0.1.1	arch.localdomain	arch



Add modules for btrfs
```bash
nvim /etc/mkinitcpio.conf
## MODULES=(btrfs)
mkinitcpio -p linux
```

User & password
```bash
usermod -aG wheel,audio,video,optical,storage mg
EDITOR=nvim visudo # uncomment wheel group access
passwd
passwd mg
```

Avoid suspend when rebooting if the lid is closed
```bash
nvim /etc/systemd/logind.conf # HandleLidSwitch=ignore
```

### Set boot loader

```bash
pacman -S grub grub-btrfs efibootmgr # add os-prober for dual boot
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
```

Enable microcode updates 
grub-mkconfig will automatically detect the microcode update and configure GRUB appropriately. After installing the microcode package, regenerate the GRUB config to activate loading the microcode update by running:

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

### Install paru-AUR helper , .dotfiles & scripts 

```bash
su mg
cd
git clone https://github.com/magiliberto/.dotfiles
git clone https://aur.archlinux.org/paru-git.git
cd paru-git
makepkg -si
cd
rm -rf paru-git
```

### Install wireless drivers

```bash
paru -S rtl8821ce-dkms-git
```

Wi-Fi not working for kernel >= 5.9
The Linux Kernel 5.9 version comes with a broken rtw88 module developed by Realtek that has poor compatibility with most revision of the 8821ce chip.

You must disable it by adding the following to your module blacklists (/etc/modprobe.d/blacklist.conf):

```bash
echo "blacklist rtw88_8821ce" | sudo tee -a /etc/modprobe.d/blacklist.conf  
```

### Reboot

```bash
exit # exit user
exit # exit chroot environment
umount -R /mnt
reboot
```

### Set WiFi & ethernet connections

```bash
nmcli device wifi list
nmcli device
nmcli connection show

sudo nmcli device wifi connect "Fibertel WiFi390 2.4GHz" password 0143534166
sudo nmcli connection delete "Wired connection 1"
sudo nmcli connection add type ethernet con-name eth1 autoconnect yes ifname eno1 ip4 192.168.0.33/24 gw4 192.168.0.1
```

### Snapper snapshot

Configuration
```bash
sudo umount /.snapshots
sudo rm -rf /.snapshots
sudo snapper -c root create-config /
sudo mount -o noatime,compress=lzo,space_cache,subvol=@.snapshots /dev/sda3 /.snapshots
sudo nvim /etc/snapper/configs/root # ALLOW_USERS="mg"
sudo chmod a+rx /.snapshots/
```

Snapshot
```bash
sudo snapper -c root create --description="after-base-installation"
reboot
```

Commands
```bash
btrfs subvol list -p /
snapper list-configs
snapper -c root list
```

Restore (from usb iso)
```bash
mount /dev/sda3 /mnt
rm -rf /mnt/@
btrfs subvol snapshot /mnt/@.snapshots/#/snapshot /mnt/@
# once inside system git pull .dotfiles
```


pull repositoy

acpi acpi_call tlp acpid network-manager-applet 

git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
bash
base16_solarized-dark
## Video & Audio drivers

### Sound - Pipewire
alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack

Add modules for intel 
```bash
nvim /etc/mkinitcpio.conf
## MODULES=(btrfs i915)
mkinitcpio -p linux
```
sudo pacman -S mesa lib32-mesa vulkan-intel libva-intel-driver libva-utils


## Graphical enviroment
* Wayland

* Qtile
```bash
paru -Syy python-pywlroots python-dbus-next alacritty
git clone git://github.com/qtile/qtile.git
cd qtile
pip install .
rm -rf qtile

XKB_DEFAULT_LAYOUT=latam qtile start -b wayland
```

```bash
sudo pacman -S keepassxc wl-clipboard insync librewolf brave
brave --enable-features=UseOzonePlatform --ozone-platform=wayland
```

## Sound
* Pipewire
alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack

Add modules for intel 
```bash
nvim /etc/mkinitcpio.conf
## MODULES=(btrfs i915)
mkinitcpio -p linux
```
sudo pacman -S mesa lib32-mesa vulkan-intel libva-intel-driver libva-utils

sudo pacman -S sway swaylock swayidle alacritty firefox xorg-xwaylan xdg-utils keepassxc
paru -S nerd-fonts-source-code-pro  


