#!/bin/bash

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
	echo -e "\n${redColour}[!]Saliendo...\n${endColour}"
	kill $checkingLid_pid > /dev/null 2>&1
	wait $checkingLid_pid > /dev/null 2>&1
	rm lastVideo.mp4 2>/dev/null
	rm lastPhoto.jpg 2>/dev/null
	tput cnorm 2>/dev/null
	exit 1
}

trap ctrl_c INT

# VARIABLES A CAMBIAR
gmail_account="tugmail@gmail.com" #Configura el archivo .muttrc en la carpeta /root
lid_state_file="/proc/acpi/button/lid/LID/state" #Comprueba si este es el archivo que muestra si la tapa del portátil está abierta o cerrada
/usr/bin/xfce4-power-manager &>/dev/null & disown # Inicia tu power manager , este es el mío, quizás debas cambiarlo
#Configurarlo para que cuando la tapa se cierre solo se bloquee

function checkingLid(){
	while true ; do
		lid_state=$(cat /proc/acpi/button/lid/LID/state | awk '{print $2}')
		if [ "$lid_state" != "open" ]; then
			while true ; do
				echo "La tapa se encuentra cerrada" | /usr/bin/mutt -s "[!] Atención TAPA CERRADA" -- "$gmail_account"
                		sleep 2
			done
		fi
		sleep 1
	done
}

function lidOpen(){
	counter=1
	while true ; do
		echo -e "${greenColour}[+] ESTADO DE LA TAPA : $lid_state ${endColour}"
		echo -e "${greenColour}[+] GRABACIÓN EN CURSO${endColour}"
		/usr/bin/ffmpeg -f v4l2 -i /dev/video0 -t 30 -c:v libx264 -crf 30 -preset ultrafast lastVideo.mp4 > /dev/null 2>&1
		yes | /usr/bin/ffmpeg -f video4linux2 -i /dev/video0 -vframes 1 lastPhoto.jpg > /dev/null 2>&1
		# Envía el vídeo
		clear
		echo -e "${greenColour}[+] ESTADO DE LA TAPA : $lid_state ${endColour}"
		echo -e "${yellowColour}[+] ENVIANDO GRABACIÓN ...${endColour}"
		echo "Tamaño :" $(ls -lh | grep Vid | awk '{print $5}') "Estado : $lid_state" | /usr/bin/mutt -s "[#$counter] $(LC_TIME=es_ES.UTF-8 date)" -a "lastVideo.mp4" -a "lastPhoto.jpg" -- "$gmail_account"
		clear
		counter=$((counter+1))
		rm lastVideo.mp4 2>/dev/null
    	done
}


#MAIN
if [ "$EUID" -ne 0 ]; then
	echo -e "${redColour}[!] Ejecuta este script con sudo${endColour}"
fi
tput civis
lid_state=$(cat /proc/acpi/button/lid/LID/state | awk '{print $2}')
checkingLid &
checkingLid_pid=$!
lidOpen
