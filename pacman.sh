#!/bin/bash

#Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

#Text Formats
BOLD=$(tput bold)
ITALIC=$(tput sitm)
NORMAL=$(tput sgr0)

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
    if [[ ${UID} -eq 0 ]]; then
        printf "Avoid running this script as root\n"
        printf "Read More: ${ITALIC}${ORANGE} https://wiki.archlinux.org/index.php/Makepkg#Usage${NC}${NORMAL}\n"
        printf "exiting now ...\n"
        exit 1
    fi
}

checkSudo

checkOrExit() {
    echo
    echo
    echo -e "${BOLD}Press ENTER to perform additional tasks or type Q to Quit ${NORMAL}"
    read CMOCUSERINPUT

    if [[ $CMOCUSERINPUT == "q" || $CMOCUSERINPUT == "Q" ]]; then
        clear
        echo "Nothing to do"
        exit 0
    elif [[ -z $CMOCUSERINPUT ]]; then
        clear
    else
        printf "${RED}Invalid Option ${NC}\n"
        exit 1
    fi
}

mainFunction() {
    clear
    read -p "
    1 => Update your system package list
    2 => Update & Upgrade you system
    3 => Install a specific package 
    4 => List all installed local packages
    5 => Search for a certain package
    6 => Uninstall a package
    7 => Uninstall unwanted packages
    8 => List recently installed / updated packages
    Q => EXIT: 

    Enter an option: " USERINPUT

    case $USERINPUT in
    1)
        printf "${GREEN}${ITALIC}updating your system package list ${NORMAL}${NC}"
        sleep 0.5s &
        spinner
        sudo pacman -Syy
        checkOrExit
        ;;
    2)
        printf "${GREEN}${ITALIC}updating and upgrading your system ${NORMAL}${NC}"
        sleep 0.5s &
        spinner
        which yay
        if [[ $? -eq 0 ]]; then
            printf "${ITALIC}Found yay installed ${NORMAL}\n"
            echo "Updating AUR packages too"
            yay -Syu
        else
            printf "${ITALIC}yay not installed${NORMAL}\n"
            echo "Perfoming normal system upgrade"
            sudo pacman -Syu
        fi
        checkOrExit
        ;;
    3)
        read -p "Enter the name of the package you want to install: " PACKAGENAME
        printf "${GREEN}${ITALIC}Installing $PACKAGENAME ${NORMAL}${NC}" &
        sleep 0.5s &
        spinner
        sudo pacman -S $PACKAGENAME
        checkOrExit
        ;;
    4)
        printf "${GREEN}${ITALIC}Listing all installed packages ${NORMAL}${NC}" &
        sleep 0.5s &
        spinner
        sudo pacman -Qe
        checkOrExit
        ;;
    5)
        read -p "Search for a package: " PACKAGENAME
        printf "${GREEN}${ITALIC}Searching for packages named $PACKAGENAME ${NORMAL}${NC}"
        sleep 0.5s &
        spinner
        echo
        sudo pacman -Qe | grep $PACKAGENAME
        checkOrExit
        ;;
    6)
        read -p "Enter the name of the package you want to uninstall: " PACKAGENAME
        printf "${RED}${ITALIC}Uninstalling $PACKAGENAME ${NORMAL}${NC}"
        sleep 0.5s &
        spinner
        sudo pacman -Rsc $PACKAGENAME
        checkOrExit
        ;;
    7)
        printf "${GREEN}${ITALIC}Uninstalling unwanted packages ${NORMAL}${NC}"
        sleep 0.5s &
        spinner
        pacman -Rns $(pacman -Qdtq)
        if [[ $? -ne 0 ]]; then
            printf "${GREEN}No unwanted packages found ${NC}"
        fi
        checkOrExit
        ;;
    8)
        read -p "List recently 1 => installed / 2 => upgraded packages: " NUM
        if [[ $NUM -eq 1 ]]; then
            grep -i installed /var/log/pacman.log
            checkOrExit
        elif [[ $NUM -eq 2 ]]; then
            grep -i upgraded /var/log/pacman.log
            checkOrExit
        else
            printf "${RED}Invalid option${NC}"
            checkOrExit
        fi

        ;;
    q)
        clear
        echo
        echo "Nothing to do"
        exit 0
        ;;
    Q)
        clear
        echo
        echo "Nothing to do"
        exit 0
        ;;
    *)
        printf "${RED}Invalid option ${NC}\n"
        ;;
    esac
}

while [[ $USERINPUT -ne "q" ]] || [[ $USERINPUT -ne "Q" ]]; do
    mainFunction
done
