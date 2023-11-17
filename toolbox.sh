#!/bin/bash

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #
# =-= Couleur sur le terminal =-= #
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #
rouge_start="\033[31m"
rouge_end="\033[0m"
vert_start="\033[32m"
vert_end="\033[0m"
bleu_start="\033[36m"
bleu_end="\033[0m"


# =-=-=-=-=-=-=-=-=-=-= #
# =-= Les fonctions =-= #
# =-=-=-=-=-=-=-=-=-=-= #

# Fonction appelée en cas d'interruption clavier (Ctrl+C)
interrupt_handler(){
    echo -e "\n${rouge_start}[!] Interruption clavier détectée. Arrêt de l'installation.${rouge_end}"
    exit 1
}

# Vérifie que le packet est installé
is_install(){
    dpkg -s "$1" &> /dev/null
    return $?
}

animation(){
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
}

check_install(){
    if [ $? -ne 0 ]; then
        echo -e "${rouge_start}[!] Erreur : Impossible d'installer $1.${rouge_end}"
        return 0
    else
        echo -e "${vert_start}[+] $1 installé avec succès dans $2.${vert_end}"
        return 1
    fi
}

animation_dl(){
    # Permet de faire un affichage animé avec des points tant que le l'installation du packet n'est pas terminé
    local -a spin_dot=(".  " ".. " "..." " .." "  ." "   ")
    local i=0
    while ps -p $! &> /dev/null; do
        local char="${spin_dot[$i]}"
        echo -ne "\r[*] Téléchargement de $1 en cours$char"
        sleep 0.1
        i=$(( (i+1) % ${#spin_dot[@]}))
    done
    wait
    echo # Saut de ligne
}

check_dl(){
    if [ $? -ne 0 ]; then
        echo -e "${rouge_start}[!] Erreur : Impossible de télécharger $1.${rouge_end}"
        return 0
    else
        echo -e "${vert_start}[+] $1 téléchargé avec succès dans $2.${vert_end}"
        return 1
    fi
}

tool_is_install(){
    if command -v $1 &> /dev/null; then
        echo -e "${vert_start}[+] $1 est déjà installé.${vert_end}"
        return 1
    else
        return 0
    fi
}

print_install(){
    if [ $? -ne 0 ]; then
        echo -e "${rouge_start}[-] Erreur : L'installation de $1 ne s'est pas effectué correctement.${rouge_end}"
    fi
}


# =-=-=-=--=-= #
# =-= Main =-= #
# =-=-=-=--=-= #

# Définir le gestionnaire d'interruption clavier
trap interrupt_handler SIGINT

ping -c 3 -W 3 "google.com" &> /dev/null
if [ $? -ne 0 ]; then
    echo -e "${rouge_start}[-] Erreur : Aucune connection à internet ou connection instable.${rouge_end}"
    exit 1
fi

# Installation de figlet et lolcat pour l'affichage du nom du script
if is_install "figlet" && is_install "lolcat"; then
    figlet ToolBox | lolcat
fi

# Vérifie que les deux fichier d'installation sont au même endroit
path_root="./toolbox_root.sh"
if [ ! -e $path_root ]; then
    echo -e "${rouge_start}[-] Erreur : Le deuxième fichier n'est pas présent dans le même répertoire que celui ci.${rouge_end}"
    exit 1
fi

# Vérifie que le deuxième fichier est bien exécutable
if [ ! -x $path_root ]; then
    echo -e "${rouge_start}[-] Erreur : Le deuxième fichier n'est pas exécutable, pour résoudre le problème chmod +x $path_root.${rouge_end}"
    exit 1
fi

echo "Veuillez sélectionner un chemin d'accès relatif d'un dossier pour stocker tous les outils (il sera crée si il n'existe pas)."
echo "~/ ne fonctionnera pas, son équivalent est $HOME"
read -p "> " path

check=true
# Vérifie que le chemin existe
if [ ! -d $path ]; then
    mkdir $path
    if [ $? -ne 0 ]; then
        echo -e "${rouge_start}[-] Erreur : Le chemin d'accès $path n'est pas trouvable.${rouge_end}"
        check=false
    fi
fi

echo "Une partie de ce script à besoin de droit root. Voulez vous l'autoriser a exécuter des commandes root ? y/n (recommandé)"
read -p ">" input

if [ $input == "y" ]; then
    su -c "$path_root"
elif [ $input != "n" ]; then
    echo -e "${rouge_start}[-] Erreur de saisie.${rouge_end}"
    exit 1
fi

if ! $check; then
    clear
    exit 1
fi

# Installation des outils depuis github
tool1="https://github.com/00xBAD/kali-wordlists"
tool1_label="wordlists"

tool2="https://github.com/radareorg/radare2"
tool2_label="radare2"

tool3="http://downloads.volatilityfoundation.org/releases/2.6/volatility_2.6_lin64_standalone.zip"
tool3_label="volatility"

tool4="https://github.com/sleuthkit/autopsy/releases/download/autopsy-4.10.0/autopsy-4.10.0.zip"
tool4_requirement="https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.12.1/sleuthkit-java_4.12.1-1_amd64.deb"
tool4_label="autopsy"
tool4_requirement_label="autopsy requirement"

tool5="https://portswigger-cdn.net/burp/releases/download?product=community&version=2023.10.1.1&type=Linux"
tool5_label="burpsuite"

# Installation de l'outil 1
mkdir -p $path/$tool1_label
if [ $? -eq 0 ]; then
    git clone $tool1 $path/$tool1_label &> /dev/null &
    animation_dl "wordlists"
    check_dl "wordlists" "$path/$tool1_label"
else
    echo -e "${rouge_start}[-] Erreur : Mot de passe incorrect, impossible d'installer $tool1_label.${rouge_end}"
fi

# Installation de l'outil 2
mkdir -p $path/$tool2_label
tool_is_install $tool2_label
if [ $? -eq 0 ]; then
    # Téléchargement de l'outil
    git clone $tool2 $path/$tool2_label &> /dev/null &
    animation_dl $tool2_label
    check_dl $tool2_label $path/$tool2_label
    if [ $? -eq 1 ]; then
        # Installation de l'outil
        echo "Pour l'installation de $tool2_label, il faut avoir les droits root."
        su -c "$path/radare2/sys/install.sh &> /dev/null &"
        animation $tool2_label
        check_install $tool2_label $path/$tool2_label
        if [ $? -eq 1 ]; then
            print_install tool2_label
            echo "(L'installation n'est pas vraiment terminer, elle est passé en arrière plan, il faut peut être attendre un peu avant de pouvoir s'en servir)"
        fi
    fi
 fi

# Installation de l'outil 3
mkdir -p $path/$tool3_label
tool_is_install $tool3_label
if [ $? -eq 0 ]; then
    # Téléchargement de l'outil
    wget $tool3 -O $path/$tool3_label/$tool3_label.zip &> /dev/null &
    animation_dl $tool3_label
    check_dl $tool3_label $path/$tool3_label
    if [ $? -eq 1 ]; then
        # Installation de l'outil
        unzip $path/$tool3_label/$tool3_label.zip -d $path/$tool3_label &> /dev/null &
        animation $tool3_label
        echo "alias volatility=\"$path/$tool3_label/volatility_2.6_lin64_standalone/volatility_2.6_lin64_standalone\"" >> $HOME/.bashrc
        check_install $tool3_label $path/$tool3_label
        if [ $? -eq 1 ]; then
            print_install $tool3_label
            echo "Alias crée dans $HOME/.bashrc"
        fi
    fi
fi

# Installation de l'outls 4
#mkdir -p $path/$tool4_label
#tool_is_install $tool4_label
#if [ $? -eq 0 ]; then
#    # Téléchargement du requirement
#    wget -r -np --directory-prefix=$path/$tool4_label $tool4_requirement &> /dev/null &
#    animation_dl $tool4_requirement_label
#    check_dl $tool4_requirement_label $path/$tool4_label
#    if [ $? -eq 1 ]; then
#        # Installation de l'outil
#        apt -y install $path/$tool4_label/sleuthkit-java_4.12.1-1_amd64.deb &> /dev/null &
#        animation $tool4_requirement_label
#        check_install $tool4_requirement_label $path/$tool4_label
#        if [ $? -eq 1 ]; then
#            print_install $tool4_requirement_label
#        fi
#    fi
#
#    # Téléchargement de l'outil
#    wget -r -np --directory-prefix=$path/$tool4_label $tool4 &> /dev/null &
#    animation_dl $tool4_label
#    check_dl $tool4_label $path/$tool4_label
#    if [ $? -eq 1 ]; then
#        unzip autopsy-4.10.0.zip &> /dev/null &
#        animation $tool4_label
#        mv autopsy-4.10.0 /opt &> /dev/null
#        temp=pwd
#        cd /opt/autopsy-4.10.0 &> /dev/null
#        export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_212 &> /dev/null
#        sh unix_setup.sh &> /dev/null &
#        animation $tool4_label
#        check_install $tool4_label $path/$tool4_label
#        if [ $check -eq 1 ]; then
#            print_install $tool4_label
#        cd $pwd
#    fi
#fi

# Installation de l'outil 5
mkdir -p $path/$tool5_label
tool_is_install $tool5_label
if [ $? -eq 0 ]; then
    # Téléchargement de l'outil
    wget $tool5 -O $path/$tool5_label/$tool5_label.sh  &> /dev/null &
    animation_dl $tool5_label
    check_dl $tool5_label $path/$tool5_label
    if [ $? -eq 1 ]; then
        print_install $tool3_label
        echo -e "${bleu_start}[*] Pour installer $tool5_label, il faut exécuter le fichier situer : $path/$tool5_label.${bleu_end}"
    fi
fi

