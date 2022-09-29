#!/bin/bash

echo "downloading pacman automation script"
wget https://raw.githubusercontent.com/yashkathe/ArchLinux-pacman-script/master/pacman.sh
mv pacman.sh ezpacman
sudo mv ezpacman /usr/local/bin
sudo chmod 755 /usr/local/bin/ezpacman
which /usr/local/bin/ezpacman
if [[ $? -eq 0 ]]; then
    echo "Run this script as ezpacman"
else
    echo "Something went wrong"
fi
