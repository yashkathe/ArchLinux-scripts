#!/bin/bash

echo "downloading pacman automation script"
wget https://raw.githubusercontent.com/yashkathe/ArchLinux-pacman-script/master/pacman.sh
mv pacman.sh wholepacman
sudo mv wholepacman /usr/local/bin
sudo chmod 755 /usr/local/bin/wholepacman
which /usr/local/bin/wholepacman
if [[ $? -eq 0 ]]; then
    echo "Run this script as wholepacman"
else
    echo "Something went wrong"
fi
