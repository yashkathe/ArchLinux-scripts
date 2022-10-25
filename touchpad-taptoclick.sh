#!/bin/bash

#Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

checkSudo() {
    if [[ ${UID} -ne 0 ]]; then
        printf "${RED}Run this script only if you have root user privileges${NC}\n"
        sleep 1s
        printf "exiting now ...\n"
        exit 1
    fi
}

checkSudo

writeToFile() {
echo "Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "TappingButtonMap" "lmr"
EndSection" > /etc/X11/xorg.conf.d/30-touchpad.conf
}

feedback() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Something went wrong${NC}"
    else
        echo -e "${GREEN}Restart your device to apply the changes${NC}"
    fi
}

if [ -f /etc/X11/xorg.conf.d/30-touchpad.conf ]; then
    printf "${ORANGE}File already present${NC} \nThis operation will rewrite to the conf file \nMake sure to make a copy of the original etc/X11/xorg.conf.d/30-touchpad.conf file \n"
    read -p "Do you want to go ahead (y/n): " USERINPUT
    if [ $USERINPUT == "y" ] || [ $USERINPUT == "Y" ] || [ $USERINPUT == "" ];then
        echo "Making a config file to enable tap to click on touchpad"
        sleep 1s
        writeToFile
        feedback
    elif [ $USERINPUT == "n" ] || [ $USERINPUT == "N" ]; then
        echo "exiting ..."
        exit 1
    else
        echo "Invalid input"
    fi
else
    echo "making a config file to enable tap to click on touchpad"
    sleep 1s
    touch /etc/X11/xorg.conf.d/30-touchpad.conf
    writeToFile
    feedback
fi
