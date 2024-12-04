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

# Fonction appelée en cas d'interruption clavier (Ctrl+C)
interrupt_handler(){
    echo -e "\n${rouge_start}[!] Interruption clavier détectée. Arrêt de l'installation.${rouge_end}"
    exit 1
}

# Vérifie que le paquet est installé
is_install(){
    if [[ $2 == "ARCH" ]]; then
        pacman -Q "$1" &> /dev/null
    else
        dpkg -s "$1" &> /dev/null
    fi
    return $?
}

animation(){
    # Permet de faire un affichage animé avec des points tant que l'installation du paquet n'est pas terminée
    local -a spin_dot=(".  " ".. " "..." " .." "  ." "   ")
    local i=0
    while ps -p $! &> /dev/null; do
        local char="${spin_dot[$i]}"
        echo -ne "\r[*] Installation de $1 en cours$char"
        sleep 0.1
        i=$(( (i+1) % ${#spin_dot[@]} ))
    done

    wait
    echo # Saut de ligne
}


# Installe le paquet
install(){
    if is_install "$1" "$2"; then
        echo -e "${vert_start}[+] $1 est déjà installé.${vert_end}"
    else
        if [[ $2 == "ARCH" ]]; then
            pacman -S --noconfirm "$1" &> /dev/null &
        else
            apt -y install "$1" &> /dev/null &
        fi
        animation "$1"
        # Vérifie que l'installation s'est correctement effectuée
        if [ $? -eq 0 ]; then
            echo -e "${vert_start}[+] $1 installé avec succès.${vert_end}"
        else
            echo -e "${rouge_start}[!] Erreur : Le paquet $1 ne s'est pas installé correctement (erreur possible : mauvaise connexion internet ou paquet obsolète).${rouge_end}"
        fi
    fi
}


# =-=-=-=--=-= #
# =-= Main =-= #
# =-=-=-=--=-= #

# Définir le gestionnaire d'interruption clavier
trap interrupt_handler SIGINT

# Vérifie que l'utilisateur a bien les droits
if [ "$EUID" -ne 0 ]; then
    echo -e "${rouge_start}[-] Erreur : Le script $0 doit être lancé en tant que root.${rouge_end}"
    exit 1
fi

# Vérifie si c'est basé sur Arch ou Debian
OS=""
if grep -iq "arch" /etc/os-release; then
    OS="ARCH"
elif grep -iq "debian" /etc/os-release; then
    OS="DEBIAN"
else
    echo -e "${rouge_start}Système d'exploitation inconnu.${rouge_end}"
    exit 1
fi

# Vérifie qu'il y a une connexion internet
ping -c 3 -W 3 "google.com" &> /dev/null
if [ $? -ne 0 ]; then
    echo -e "${rouge_start}[-] Erreur : Aucune connexion à internet ou connexion instable.${rouge_end}"
    exit 1
fi

echo "Voulez-vous mettre à jour la liste des paquets et le système ? (Y/n)"
read -p ">" input
input="${input:-y}" # Met un y en valeur par défaut
input=$(echo "$input" | tr '[:upper:]' '[:lower:]')  # Convertir en minuscule

# Si oui, mise à jour
if [ "$input" == "y" ]; then
    if [[ $OS == "ARCH" ]]; then
        pacman -Syu --noconfirm &> /dev/null &
    else
        apt -y update &> /dev/null && apt -y upgrade &> /dev/null &
    fi
    animation "Mise à jour"
    echo -e "${vert_start}[+] Mise à jour des paquets et du système effectuée.${vert_end}"
elif [ "$input" != "n" ]; then
    echo -e "${rouge_start}[-] Erreur de saisie.${rouge_end}"
    exit 1
fi

# Installation des paquets avec des ajustements spécifiques
if [[ $OS == "ARCH" ]]; then
    install "hashcat" "$OS"
    install "wireshark-qt" "$OS"  # Qt version pour interface graphique
    install "perl-image-exiftool" "$OS"
    install "nmap" "$OS"
    install "openbsd-netcat" "$OS"
    install "bind" "$OS"  # Équivalent à dnsutils
    install "curl" "$OS"
    install "dirb" "$OS"
    install "jdk-openjdk" "$OS"  # Équivalent à default-jdk
    install "net-tools" "$OS"
    install "python" "$OS"
    install "python-pip" "$OS"
    install "sqlmap" "$OS"
    install "git" "$OS"
    install "testdisk" "$OS"
    install "perl" "$OS"
    install "gdb" "$OS"
else
    install "hashcat" "$OS"
    install "wireshark" "$OS"
    install "libimage-exiftool-perl" "$OS"
    install "nmap" "$OS"
    install "netcat-openbsd" "$OS"
    install "dnsutils" "$OS"
    install "curl" "$OS"
    install "dirb" "$OS"
    install "default-jdk" "$OS"
    install "net-tools" "$OS"
    install "python3" "$OS"
    install "python3-pip" "$OS"
    install "sqlmap" "$OS"
    install "git" "$OS"
    install "testdisk" "$OS"
    install "perl" "$OS"
    install "gdb" "$OS"
fi
