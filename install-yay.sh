#!/bin/bash

#Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

spinner() {
    PID=$!
    i=1
    sp="/-\|"
    echo -n ' '
    while [ -d /proc/$PID ]; do
        printf "\b${sp:i++%${#sp}:1}"
    done
    echo
}

checkSudo() {
    if [[ ${UID} -eq 0 ]]; then
        printf "${RED}Dont run this script as root or sudo ${NC}\n"
        printf "${RED}You might have to enter password when prompted ${NC}\n"
        sleep 1s
        printf "${RED}exiting now ...  ${NC}\n"
        exit 1
    fi
}

checkSudo

preReqPackages() {
    printf "${GREEN}Installing all the prerequisite packages ${NC}"
    sleep 3s &
    spinner

    printf "${GREEN}Installing the base-devel package ${NC}"
    sleep 1.5s &
    spinner
    sudo pacman -S base-devel

    #check for git
    printf "${GREEN}Checking if git is installed ${NC}"
    sleep 1.5s &
    spinner
    command -v git
    if [[ $? -ne 0 ]]; then
        printf "${GREEN}Installing git ${NC}"
        sleep 1.5s &
        spinner
        sudo pacman -S git
    fi
}

makePackage() {
    git clone https://aur.archlinux.org/yay.git
    cd ./yay

    printf "${GREEN}Building package ${NC}"
    sleep 1.5s &
    spinner

    makepkg -s

    FILENAME=$(basename *.tar.zst)
    sudo pacman -U $FILENAME
}

validateYay() {
    which yay
    if [[ $? -eq 0 ]]; then
        printf "${GREEN}Yay installed successfully ${NC}\n"
    else
        printf "${RED}Yay was not installed, something went wrong ${NC}\n"
    fi
}

preReqPackages
makePackage
validateYay
