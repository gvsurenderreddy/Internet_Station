#!/bin/bash

# -------------------------------------------------------------------------- #
# Info                                                                       # 

# Automatisch startendes Script welches übrpüft ob die Slaxmaschine bereits
# installiert worden ist. Ansonsten wird der Installationsvorang gestartet.
# Sollten die benötigten Einstellungen vorhanden sein, wird die Website
# mit den gegebenen Parametern im Kioskmodus gestartet.

# Marius Preuss
# xpremar@gmail.com

#                                                                            #
# -------------------------------------------------------------------------- #

# -------------------------------------------------------------------------- #
# Variables                                                                  # 

WebsiteStatus=false

StartWebsite=null

#                                                                            #
# -------------------------------------------------------------------------- #

# -------------------------------------------------------------------------- #
# Functions                                                                  # 

function f_checkWebsite {
	if [ -f /home/website.txt ];
		then
			WebsiteStatus=true			
	fi
}

function f_readWebsite {
	StartWebsite=$(head -n1 /home/website.txt)
}

#                                                                            #
# -------------------------------------------------------------------------- #

# -------------------------------------------------------------------------- #
# Main                                                                       #

f_checkWebsite
if [ "$WebsiteStatus" = "false" ]
	then
		/home/slax_installer.sh
	else
		f_readWebsite
		firefox "$StartWebsite"
fi

#                                                                            #
# -------------------------------------------------------------------------- #