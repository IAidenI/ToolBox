# ToolBox
Installe les principaux outils de kali :
- [X] [Hashcat](https://www.kali.org/tools/hashcat/) : Utilisation `hashcat --help`
- [X] [Wireshark](https://www.kali.org/tools/wireshark/) : Utilisation `wireshark --help`
- [X] [ExifTool](https://www.kali.org/tools/libimage-exiftool-perl/) : Utilisation `exiftool --help`
- [X] [Nmap](https://www.kali.org/tools/nmap/) : Utilisation `nmap --help`
- [X] [Netcat](https://www.kali.org/tools/netcat/) : Utilisation `netcat/nc --help`
- [X] [Curl](https://www.kali.org/tools/curl/) : Utilisation `curl --help`
- [X] [Dirb](https://www.kali.org/tools/dirb/) : Utilisation `dirb --help`
- [X] Ifconfig/Arp/Netstat/rarp/nameif/route : Utilisation `ifconfig/arp/netstat/rarp/nameif/route --help`
- [X] Python3 : Utilisation `python3 --help`
- [X] Pip : Utilisation `pip --help`
- [X] Perl : Utilisation `perl --help`
- [X] PHP : Utilisation `php --help`
- [X] [Sqlmap](https://www.kali.org/tools/sqlmap/) : Utilisation `sqlmap --help`
- [X] [Git](https://www.kali.org/tools/git/) : Utilisation `git --help`
- [X] [Testdisk](https://www.kali.org/tools/testdisk/) : Utilisation `testdisk --help`
- [X] [Wordlists](https://github.com/00xBAD/kali-wordlists) : Utilisation `dirb --help`
- [X] [Radare2](https://github.com/radareorg/radare2) : Utilisation `radare2/r2 --help`
- [X] [Volatility](https://www.volatilityfoundation.org/) : Utilisation `volatility --help`
- [ ] [Autopsy](https://www.autopsy.com/)
- [X] [BurpSuite](https://portswigger.net/burp) : Installation manuelle requis

## Prérequis
Pour avoir un meilleur affichage :
<pre><code>sudo apt -y install figlet && apt -y install lolcat</code></pre>

## Installation
<pre><code>
git clone https://github.com/IAidenI/ToolBox
cd ToolBox
chmod +x toolbox.sh && chmod +x toolbox_root.sh
./toolbox.sh
</code></pre>
**Note** : Les deux fichiers doivent être présents dans le même répertoire.

## Possible problème
Si l'un des packets (ex : wireshark) met énormément de temps à s'installer (> 5min) arrêter le programme et faire `ps -aux | grep -e "apt"` copier l'id du packet qui pose problème et faire `sudo kill id_du_packet` et relancer l'application.

## ToDoList

- [X] Si un seul des fichiers est exécutable et pas le deuxième
- [X] Interuption clavier
- [X] Problème wordlist
- [X] Problème radare2
- [ ] Sanitarize path (ban ~ ../)
- [ ] Autopsy
- [ ] Processus qui se termine pas, obligé de ps -aux | grep -e "apt" --> sudo kill <processus bloqué>
