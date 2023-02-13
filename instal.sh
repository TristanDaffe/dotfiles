#!/bin/bash

# install app
sudo apt install cava rofi kitty neofetch rofi
# install using snap for more up to date
sudo snap install nvim

# get current directory
gitpath=`pwd`

ln -s $gitpath/cava/ ~/.config/cava
ln -s $gitpath/kitty/ ~/.config/kitty
ln -s $gitpath/neofetch/ ~/.config/neofetch
ln -s $gitpath/nvim/ ~/.config/nvim
ln -s $gitpath/rofi/ ~/.config/rofi
