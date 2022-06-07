#!/bin/bash

#Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

USERINPUT=100

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
    if [[ ${UID} -ne 0 ]]; then
        printf "${RED}ERROR ! start this script as root ${NC}\n"
        printf "${RED}exiting now ...  ${NC}" 
        sleep 0.5s &
        spinner
        exit 1
    fi
}

checkSudo

mainFunction() {
    read -p "
    1 => Update your system package list
    2 => Update & Upgrade you system
    3 => Install a specific package 
    4 => List all installed local packages
    5 => Uninstall a package
    6 => Uninstall unwanted packages
    Q => EXIT: 
    Enter an option: " USERINPUT

    case $USERINPUT in
    1)
        printf "${GREEN}updating your system package list  ${NC}"
        sleep 1s &
        spinner
        sudo pacman -Syy
        ;;
    2)
        printf "${GREEN}updating and upgrading your system ${NC}"
        sleep 1s &
        spinner
        sudo pacman -Syu
        ;;
    3)
        read -p "Enter the name of the package you want to install: " PACKAGENAME
        printf "${GREEN} Installing $PACKAGENAME ${NC}" &
        sleep 1s &
        spinner
        sudo pacman -S $PACKAGENAME
        ;;
    4)
        printf "${GREEN}Listing all installed packages  ${NC}" &
        sleep 1s &
        spinner
        sudo pacman -Qe
        ;;
    5)
        read -p "Enter the name of the package you want to uninstall: " PACKAGENAME
        printf "${RED} Uninstalling $PACKAGENAME ${NC}" 
        sleep 1s &
        spinner
        sudo pacman -Rsc $PACKAGENAME
        ;;
    6)
        printf "${GREEN}Uninstalling unnecessary packages  ${NC}" 
        sleep 1s &
        spinner
        pacman -Rns $(pacman -Qdtq)
        ;;
    *)
        printf "${RED}Invalid option  ${NC}" 
        sleep 0.3s &
        spinner
    esac
}

while [[ $USERINPUT -ne "q" ]] || [[ $USERINPUT -ne "Q" ]]; do
    mainFunction
done
