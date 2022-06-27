#!/bin/bash
# INSTALL DEPENDENCIES
sudo pacman -S --needed base-devel git xmonad xmonad-contrib xmobar alacritty fish rofi

# install from aur
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
yay -S picom-git ly

# MOVE FILES TO CORRECT LOCATIONS
mkdir ~/Pictures
mkdir ~/Pictures/Walls
mkdir ~/.xmonad
mkdir ~/.config/xmobar
mkdir ~/.config/xmobar/scripts
mkdir ~/.config/picom
mkdir ~/.config/alacritty
mkdir ~/.config/fish
mkdir ~/.config/fish/functions

cp wallpaper.jpg ~/Pictures/Walls/primal_ice.jpg
cp xmonad/xmonad.hs ~/.xmonad/xmonad.hs
cp xmobar/xmobarrc ~/.config/xmobar/xmobarrc
cp scripts/xmobar/orphans.sh ~/.config/xmobar/scripts/orphans.sh
cp scripts/xmobar/numpkgs.sh ~/.config/xmobar/scripts/numpkgs.sh
cp picom/picom.conf ~/.config/picom/picom.conf
cp alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
cp fish/config.fish ~/.config/fish/config.fish
cp fish/fish_variables ~/.config/fish/fish_variables
cp fish/functions/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish
sudo rm -rf /etc/ly/config.ini
sudo cp ly/config.ini /etc/ly/config.ini

# ENABLE LY
sudo systemctl enable ly.service
sudo systemctl disable getty@tty2.service

# CLEAN UP SYSTEM
sudo pacman -R $(pacman -Qtdq)

