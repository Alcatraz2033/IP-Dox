#!/bin/bash

RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"
RESETBG="$(printf '\e[0m\n')" endColour="$(printf '\033[0m\e[0m')"

function ctrl_c(){
    echo -e "\n${RED}[!] Saliendo...${endColour}"
    rm *.tmp
    exit 1
}
trap ctrl_c INT

function helpPanel(){
    echo -e "\n${CYAN}[!] Uso: ./ip_doxx.sh -u https://www.example.com -t 30${endColour}"
    for i in $(seq 1 83); do echo -ne "${CYAN}-"; done; echo -ne "${endColour}"
    echo -e "\n\n\t[-u]${MAGENTA} URL a camuflar${endColour}"
    echo -e "\n\t[-t]${MAGENTA} Tiempo en segundos que se actualiza el script${endColour}${CYAN} Ejemplo: -t 30${endColour}"
    echo -e "\n\t[-h]${MAGENTA} Mostrar este panel de ayuda${endColour}"
    exit 1
}

if [ $(id -u) -ne "0" ];then
	echo -e "\n${RED} [!] Ejecute este script como root...${endColour}"
	exit 1
fi

function cheker(){

	which xclip &>/dev/null
	if [ $? -ne "0" ];then
		echo -e "\n${CYAN}[+] Instalando xclip...${endColour}"
		sudo apt install xclip &>/dev/null
	fi
}

banner() {
	cat <<- EOF
    
${CYAN}⣿⣿⡻⠿⣳⠸⢿⡇⢇⣿⡧⢹⠿⣿⣿⣿⣿⣾⣿⡇⣿⣿⣿⣿⡿⡐⣯⠁  ${MAGENTA}   /$\$\$\$\$\$ /$\$\$\$\$\$\$ 
${CYAN}⠟⣛⣽⡳⠼⠄⠈⣷⡾⣥⣱⠃⠣⣿⣿⣿⣯⣭⠽⡇⣿⣿⣿⣿⣟⢢⠏   ${MAGENTA}  |_  $\$_/| $\$__  $\$
${CYAN}⢠⡿⠶⣮⣝⣿  ⠈⡥⢭⣥⠅⢌⣽⣿⣻⢶⣭⡿⠿⠜⢿⣿⣿⡿⠁    ${MAGENTA}   | $\$  | $\$  \ $\$
${CYAN} ⣼⣧⠤⢌⣭⡇   ⠭⠭⠭⠯⠴⣚⣉⣛⡢⠭⠵⢶⣾⣦⡍⠁      ${MAGENTA}  | $\$  | $\$\$\$\$\$\$/
${CYAN} ⣿⣷⣯⣭⡷  ⢀⣀⠩⠍⢉⣛⣛⠫⢏⣈⣭⣥⣶⣶⣦⣭⣛       ${MAGENTA}  | $\$  | $\$____/ 
${CYAN}⢀⣿⣿⣿⡿⠃⢀⣴⣿⣿⣿⣎⢩⠌⣡⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆    ${MAGENTA}   | $\$  | $\$
${CYAN}⢸⡿⢟⣽⠎⣰⣿⣿⣿⣿⣿⣿⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦   ${MAGENTA}  /$\$\$\$\$\$| $\$
${CYAN}⣰⠯⣾⢅⣼⣿⣿⣿⣿⣿⣿⡇⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄  ${MAGENTA} |______/|__/ ${CYAN} BY: Alcatraz2033
${CYAN}⢰⣄⡉⣼⣿⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧  ${MAGENTA}  /$\$\$\$\$\$\$   /$\$\$\$\$\$  /$\$   /$\$ /$\$   /$\$
${CYAN}⢯⣌⢹⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿  ${MAGENTA} | $\$__  $\$ /$\$__  $\$| $\$  / $\$| $\$  / $\$
${CYAN}⢸⣇⣽⣿⣿⣿⣿⣿⣿⣿⣿⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿  ${MAGENTA} | $\$  \ $\$| $\$  \ $\$|  $\$/ $\$/|  $\$/ $\$/
${CYAN}⢸⣟⣧⡻⣿⣿⣿⣿⣿⣿⣿⣧⡻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿  ${MAGENTA} | $\$  | $\$| $\$  | $\$ \  $\$\$\$/  \  $\$\$\$/
${CYAN}⠈⢹⡧⣿⣸⠿⢿⣿⣿⣿⣿⡿⠗⣈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇  ${MAGENTA} | $\$  | $\$| $\$  | $\$  >$\$  $\$   >$\$  $\$ 
${CYAN} ⠘⢷⡳⣾⣷⣶⣶⣶⣶⣶⣾⣿⣿⢀⣶⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇  ${MAGENTA} | $\$  | $\$| $\$  | $\$ /$\$/\  $\$ /$\$/\  $\$
${CYAN}  ⠈⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿    ${MAGENTA}| $\$\$\$\$\$\$/|  $\$\$\$\$\$/| $\$  \ $\$| $\$  \ $\$
${CYAN}   ⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇    ${MAGENTA}|_______/  \______/ |__/  |__/|__/  |__/
	EOF
}

function process(){

    banner
    cheker
    curl -s --data "source_url=$1&create=Create+URL" https://tracker.iplocation.net/ip_shortener | html2text > temp.tmp 

    enviar=$(grep "COPY" temp.tmp | awk '{print $(NF-1)}')
    revisar=$(grep "https://tracker.iplocation.net/t/" temp.tmp | awk '{print $NF}')

    echo -e "\n${GREEN}[*] Envie este link: ${endColour}$enviar"
    echo $enviar | xclip -sel clip &>/dev/null
    echo -e "${GREEN}[*] Link copiado en la clipboard ${endColour}"
    echo -e "\n${GREEN}[*] Esperando por conecciones...${endColour}"

    while true;do

        sleep $2
        curl -s $revisar > revisar.tmp 
        sape=$(cat revisar.tmp | grep "Traffic Analytics" | awk '{print $NF}')
        if [ $sape == "(1)</p>" ]; then
            cat revisar.tmp | grep "data-date="\" > datos.tmp
            date_time=$(cat datos.tmp | grep -o '".*"' | awk -F= '{print $16}' | grep -o '".*"' | tr -d '"') 
            ip_address=$(cat datos.tmp | grep -o '".*"' | awk -F= '{print $15}' | grep -o '".*"' | tr -d '"')
            proxy=$(cat datos.tmp | grep -o '".*"' | awk -F= '{print $11}' | grep -o '".*"' | tr -d '"')
            pais=$(cat datos.tmp | grep -o '".*"' | awk -F= '{print $10}' | grep -o '".*"' | tr -d '"')
            region=$(cat datos.tmp | grep -o '".*"' | awk -F= '{print $13}' | grep -o '".*"' | tr -d '"')
            city=$(cat datos.tmp | grep -o '".*"' | awk -F= '{print $12}' | grep -o '".*"' | tr -d '"')
            isp=$(cat datos.tmp | grep -o '".*"' | awk -F= '{print $8}' | grep -o '".*"' | tr -d '"')
            user_agent=$(cat datos.tmp | grep -o '".*"' | awk -F= '{print $18}' | grep -o '".*"' | tr -d '"')
            platform=$(cat datos.tmp | grep -o '".*"' | awk -F= '{print $7}' | grep -o '".*"' | tr -d '"')
            os=$(cat datos.tmp | grep -o '".*"' | awk -F= '{print $9}' | grep -o '".*"' | tr -d '"')
            browser=$(cat datos.tmp | grep -o '".*"' | awk -F= '{print $6}' | grep -o '".*"' | tr -d '"')
            language=$(cat datos.tmp | grep -o '".*"' | awk -F= '{print $(NF - 1)}' | grep -o '".*"' | tr -d '"')
            incognit_mode=$(cat datos.tmp | grep -o '".*"' | awk -F= '{print $(NF - 2)}' | grep -o '".*"' | tr -d '"')
            location=$(cat revisar.tmp | grep "geolocation?id" | awk '{print $(NF-1)}' | sed 's/href="//' | sed 's/"><img//')

            for i in $(seq 1 83); do echo -ne "${CYAN}-"; done; echo -ne "${endColour}"
            echo -e "\n${CYAN}Fecha y hora: ${endColour}$date_time"
            echo -e "${CYAN}Direccion IP: ${endColour}$ip_address"
            echo -e "${CYAN}Proxy: ${endColour}$proxy"
            echo -e "${CYAN}Pais: ${endColour}$pais"
            echo -e "${CYAN}Region: ${endColour}$region"
            echo -e "${CYAN}Ciudad: ${endColour}$city"
            echo -e "${CYAN}ISP: ${endColour}$isp"
            echo -e "${CYAN}User Agent: ${endColour}$user_agent"
            echo -e "${CYAN}Plataforma: ${endColour}$platform"
            echo -e "${CYAN}Sistema operativo: ${endColour}$os"
            echo -e "${CYAN}Navegador: ${endColour}$browser"
            echo -e "${CYAN}Idioma: ${endColour}$language"
            echo -e "${CYAN}Modo Incognito: ${endColour}$incognit_mode"
            echo -e "${CYAN}Locacion: ${endColour}$location"
            rm *.tmp
            break
        fi 
    done 
}

parameter_counter=0; while getopts "u:t:h:" arg; do
    case $arg in
        u) url=$OPTARG; let parameter_counter+=1;;
        t) time=$OPTARG; let parameter_counter+=1;;
        h) helpPanel;; 
    esac  
done

if [ $parameter_counter -eq 0 ]; then
    helpPanel
    else
        if [ ! $time ]; then
            helpPanel
        else
            process $url $time
        fi  
fi
