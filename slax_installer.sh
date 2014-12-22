#!/bin/bash

# -------------------------------------------------------------------------- #
# Info                                                                       # 

# Automatisches Script zum erstellen einer Internet Station auf der Basis von
# Slax. Ermöglich die Einstellung vom Passwort, Proxy, Internet und
# der automatisch zu öffnenden Website.

# Marius Preuss
# xpremar@gmail.com

#                                                                            #
# -------------------------------------------------------------------------- #

# -------------------------------------------------------------------------- #
# Variables                                                                  # 

PasswordStatus=false
ProxyStatus=false
InternetStatus=false
WebsiteStatus=false

ValidatorStatus=false

StartWebsite=null

InstallerStart=true

#                                                                            #
# -------------------------------------------------------------------------- #


# -------------------------------------------------------------------------- #
# Functions                                                                  # 

function f_internetCheck {
	echo -e "Verbindung wird getestet, bitte warten ..."
	wget -q --tries=10 --timeout=20 --spider "http://google.com"
	if [[ $? -eq 0 ]]; then
        echo -e "es wurde erfolgreich eine Verbindung hergestellt.\n"
		InternetStatus=true
	else
        echo -e "es konnte keine Verbindung hergestellt werden.\n"
	fi
}

function f_proxySet {
	echo -e "Bitte die Proxy Server angeben:"
	read proxyData
	export http_proxy=$proxyData
	echo -e "Proxy wurde gesetzt."
	ProxyStatus=true
}

function f_setPassword {
	while true; do
		
		passwd
		
		if [ $? -eq 0 ]
			then
				PasswordStatus=true
				break
			else
				clear
		fi
	done
}

function f_setWebsite {
	echo -e "Bitte geben sie die Website die gestartetn werden soll ein"
	read StartWebsite
	WebsiteStatus=true
}

function f_checkInput {	
	if [ "$PasswordStatus" = "false" ]
		then
			echo -e "Bitte ändern Sie zuerst das Root Passwort."
	fi
	
	if [ "$WebsiteStatus" = "false" ]
		then
			echo -e "Bitte setzen Sie die Website die aufgerufen werden soll."
	fi
	
	if [ "$InternetStatus" = "false" ]
		then
			echo -e "Es sollten nach Möglichkeit erst ein Internettest durchgeführt werden."
	fi
	
	if [ "$WebsiteStatus" = "true" ] && [ "$PasswordStatus" = "true" ]
		then
			ValidatorStatus=true
	fi
}

function f_writeConfig {
	if [ -f /home/website.txt ];
		then
			rm /home/website.txt
			echo "$StartWebsite" > "/home/website.txt"
		else
			echo "$StartWebsite" > "/home/website.txt"
	fi
}

function f_mainMenu {

while true; do
	clear
	echo '
	  _____ _              _____           _        _ _           
	 / ____| |            |_   _|         | |      | | |          
	| (___ | | __ ___  __   | |  _ __  ___| |_ __ _| | | ___ _ __ 
	 \___ \| |/ _` \ \/ /   | | |  _ \/ __| __/ _` | | |/ _ \  __|
	 ____) | | (_| |>  <   _| |_| | | \__ \ || (_| | | |  __/ |   
	|_____/|_|\__,_/_/\_\ |_____|_| |_|___/\__\__,_|_|_|\___|_|   
																  
	Marius Preuss - xpremar@gmail.com - 12.09.2014         
	'
	echo -e "\n\t1. Neues Root Passwort setzen."
	echo -e "\t2. Proxy setzen."
	echo -e "\t3. Internet Verbindungstest."
	echo -e "\t4. Website setzen."
	echo -e "\n\t0. Einstellungen übernehmen und Computer neu starten."
	echo -n -e "\n\tAuswahl: "
	read opt

	case $opt in
		1)
		clear
		f_setPassword
		read -p "[Enter] um fortzufahren."
		;;

		2)
		clear;
		f_proxySet
		read -p "[Enter] um fortzufahren."
		;;

		3)
		clear;
		f_internetCheck
		read -p "[Enter] um fortzufahren."
		;;

		4)
		clear
		f_setWebsite
		read -p "[Enter] um fortzufahren."
		;;
				
		0)
		clear
		f_checkInput
		
		if [ "$ValidatorStatus" = "true" ]
			then
				break
			else
				read -p "[Enter] um fortzufahren."
		fi
		
		;;
	esac
	
done

echo -e "Die Einstellungen werden nun geschrieben ..."
f_writeConfig
echo -e "Einstellungen wurden erfasst, und der Computer wird nun neu starten."

read -p "[Enter] um forzufahren."

reboot

}

function f_checkWebsite {
	if [ -f /home/website.txt ];
		then
			InstallerStart=false
	fi
}

#                                                                            #
# -------------------------------------------------------------------------- #

# -------------------------------------------------------------------------- #
# Main                                                                       #

f_checkWebsite
if [ "$WebsiteStatus" = "true" ]
	then
		f_mainMenu
fi

#                                                                            #
# -------------------------------------------------------------------------- #