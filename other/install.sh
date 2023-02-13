#!/bin/bash
# install vs code
sudo snap install --classic code
# install discord
sudo snap install discord
# install git and gitkraken
sudo apt install git -y
sudo snap install gitkraken --classic
# install brave
sudo snap install brave
# install notion
sudo snap install notion-snap
# install spotify + lollypop
sudo snap install spotify
sudo apt install lollypop


#install jetbrains toolbox
#source : https://gist.github.com/greeflas/431bc50c23532eee8a7d6c1d603f3921
set -e

if [ -d ~/.local/share/JetBrains/Toolbox ]; then
    echo "JetBrains Toolbox is already installed!"
else

echo "Start installation..."

wget --show-progress -qO ./toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"

sudo tar -xvzf toolbox.tar.gz
sudo mv jetbrains-toolbox-1.27.2.13801/ jetbrains
sudo apt install libfuse2
jetbrains/jetbrains-toolbox

echo "JetBrains Toolbox was successfully installed!"
fi
# install docker + docker desktop
# source : (doc officielle)
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
 sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# install docker desktop using the docker containers
# source : https://docs.docker.com/desktop/install/linux-install/
sudo service docker start
wget --show-progress -qO ./docker-desktop.deb "https://desktop.docker.com/linux/main/amd64/docker-desktop-4.12.0-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64"
sudo apt-get install ./docker-desktop.deb

# install gnome tweaks
sudo apt install gnome-tweaks
sudo apt install gnome-shell-extension-manager -y

# install extension pop os window tiling
sudo apt install node-typescript make git -y
git clone https://github.com/pop-os/shell
cd shell
make local-install
