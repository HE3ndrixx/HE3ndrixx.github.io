#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################


red='\e[1;31m'
green='\e[1;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

clear                                       
echo -e "${red}==[ BACA TERLEBIH DAHULU ]==${NC}

1. Format harus html kalau kurang paham silahkan googling
2. Edit teks sesuai keinginan
3. Jika sudah di edit simpan tekan CTRL+x+y+enter
4. Untuk membatalkan/keluar tekan CTRL + x + n‌‌

nb : jangan lupa restart vps setelah edit banner‌‌
"
echo -n "Wanna go ? (y/n)? "
read answer
if [ -z $answer ]; then
menu-tools
fi
if [ "$answer" == "${answer#[Yy]}" ] ;then
menu-tools
else
clear
nano /etc/issue.net
menu-tools
fi
