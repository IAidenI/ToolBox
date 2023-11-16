#!/bin/bash

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #
# =-= Couleur sur le terminal =-= #
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #
rouge_start="\033[31m"
rouge_end="\033[0m"
vert_start="\033[32m"
vert_end="\033[0m"


# =-=-=-=-=-=-=-=-=-=-= #
# =-= Les fonctions =-= #
# =-=-=-=-=-=-=-=-=-=-= #

# Vérifie que le packet est installé
is_install(){
    dpkg -s "$1" &> /dev/null
    return $?
}


# Installe le packet
install(){
    if is_install "$1"; then
        echo -e "${vert_start}[+] $1 est déjà installé.${vert_end}"
    else
        apt -y install "$1" &> /dev/null &

        # Permet de faire un affichage animé avec des points tant que le l'installation du packet n'est pas terminé
        local -a spin_dot=(".  " ".. " "..." " .." "  ." "   ")
        local i=0
        while ps -p $! &> /dev/null; do
            local char="${spin_dot[$i]}"
            echo -ne "\r[*] Installation de $1 en cours$char"
            sleep 0.1
            i=$(( (i+1) % ${#spin_dot[@]}))
        done

        wait
        echo # Saut de ligne

        # Vérifie que l'instalation se soit correctement effectué
        if [ $? -eq 0 ]; then
            echo -e "${vert_start}[+] $1 installé avec succès.${vert_end}"
        else
            echo -e "${rouge_start}[!] Erreur : Le packet $1 ne s'est pas installé correctement (erreur possible : mauvase connection internet - packet obsolète).${rouge_end}"
        fi
    fi
}


# =-=-=-=--=-= #
# =-= Main =-= #
# =-=-=-=--=-= #

echo "Voulez vous faire mettre à jour la liste des packets et mettre à jour le système ? (y/n)"
read -p ">" input

# Si oui, mise à jour
if [ "$input" == "y" ]; then
    apt -y update &> /dev/null && apt -y upgrade &> /dev/null
    echo -e "${vert_start}[+] Mise à jour des packets et du système effectué.${vert_end}"
elif [ "$input" != "n" ]; then
    echo -e "${rouge_start}[-] Erreur de saisie.${rouge_end}"
    clear
    exit 1
fi

# Installation des packets
install "hashcat"
install "wireshark"
install "libimage-exiftool-perl"
install "nmap"
install "netcat-openbsd"
install "dnsutils"
install "curl"
install "dirb"
install "default-jdk"
install "net-tools"
install "python3"
install "python3-pip"
install "sqlmap"
install "git"
install "testdisk"
install "-f"
install "perl"
