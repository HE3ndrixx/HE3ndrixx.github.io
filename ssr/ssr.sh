#!/bin/bash
# My Telegram : https://t.me/geovpn
#########################
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

BURIQ () {
    curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/main/allow > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f /root/tmp
}

MYIP=$(curl -sS ipinfo.io/ip)
Name=$(curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/main/allow | grep $MYIP | awk '{print $2}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)

Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}

PERMISSION () {
    MYIP=$(curl -sS ipinfo.io/ip)
    IZIN=$(curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/main/allow | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}
clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
NC='\e[0m'
curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/ascii-home
echo "Shadowsocks-R"
echo "Progress..."
sleep 3
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
PERMISSION
if [ "$res" = "Permission Accepted..." ]; then
green "Permission Accepted.."
else
red "Permission Denied!"
exit 0
fi
echo -e "
"
date
echo ""
sleep 1
echo -e "[ ${green}INFO${NC} ] Checking... "
# ==========================================
# Link Hosting Kalian
geovpn="geovpn.github.io/ssr"

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

sh_ver="1.0.26"
filepath=$(cd "$(dirname "$0")"; pwd)
file=$(echo -e "${filepath}"|awk -F "$0" '{print $1}')
ssr_folder="/usr/local/shadowsocksr"
config_file="${ssr_folder}/config.json"
config_user_file="${ssr_folder}/user-config.json"
config_user_api_file="${ssr_folder}/userapiconfig.py"
config_user_mudb_file="${ssr_folder}/mudb.json"
ssr_log_file="${ssr_folder}/ssserver.log"
Libsodiumr_file="/usr/local/lib/libsodium.so"
Libsodiumr_ver_backup="1.0.17"
jq_file="${ssr_folder}/jq"
source /etc/os-release
OS=$ID
ver=$VERSION_ID

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[information]${Font_color_suffix}"
Error="${Red_font_prefix}[error]${Font_color_suffix}"
Tip="${Green_font_prefix}[note]${Font_color_suffix}"
Separator_1="——————————————————————————————"
check_pid(){
	PID=`ps -ef |grep -v grep | grep server.py |awk '{print $2}'`
}
Add_iptables(){
		iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 1443:1543 -j ACCEPT
		iptables -I INPUT -m state --state NEW -m udp -p udp --dport 1443:1543 -j ACCEPT
}
Save_iptables(){
if [[ ${OS} == "centos" ]]; then
		service iptables save
		service ip6tables save
else
		iptables-save > /etc/iptables.up.rules
fi
}
Set_iptables(){
if [[ ${OS} == "centos" ]]; then
		service iptables save
		service ip6tables save
		chkconfig --level 2345 iptables on
		chkconfig --level 2345 ip6tables on
else
		iptables-save > /etc/iptables.up.rules
		echo -e '#!/bin/bash\n/sbin/iptables-restore < /etc/iptables.up.rules\n/sbin/ip6tables-restore < /etc/ip6tables.up.rules' > /etc/network/if-pre-up.d/iptables
		chmod +x /etc/network/if-pre-up.d/iptables
fi
}
Set_user_api_server_pub_addr(){
ip=$(wget -qO- ipv4.icanhazip.com);
ssr_server_pub_addr="${ip}"
}
Modify_user_api_server_pub_addr(){
	sed -i "s/SERVER_PUB_ADDR = '${server_pub_addr}'/SERVER_PUB_ADDR = '${ssr_server_pub_addr}'/" ${config_user_api_file}
}
Check_python(){
if [[ ${OS} == "centos" ]]; then
if [[ $ver == '7' ]]; then
yum -y install python
elif [[ $ver == '8' ]]; then
yum install -y python2
alternatives --set python /usr/bin/python2
fi
else
apt-get install -y python
fi
}
Centos_yum(){
	yum update
	cat /etc/redhat-release |grep 7\..*|grep -i centos>/dev/null
	if [[ $? = 0 ]]; then
		yum install -y vim unzip crond net-tools git
	else
		yum install -y vim unzip crond git
	fi
}
Debian_apt(){
	apt-get update
	apt-get install -y vim unzip cron git net-tools
}
Download_SSR(){
	cd "/usr/local"
	git clone -b akkariiin/master https://github.com/shadowsocksrr/shadowsocksr.git > /dev/null 2>&1
	cd "shadowsocksr"
	cp "${ssr_folder}/config.json" "${config_user_file}"
	cp "${ssr_folder}/mysql.json" "${ssr_folder}/usermysql.json"
	cp "${ssr_folder}/apiconfig.py" "${config_user_api_file}"
	sed -i "s/API_INTERFACE = 'sspanelv2'/API_INTERFACE = 'mudbjson'/" ${config_user_api_file}
	server_pub_addr="127.0.0.1"
	Modify_user_api_server_pub_addr
	sed -i 's/ \/\/ only works under multi-user mode//g' "${config_user_file}"
}
Service_SSR(){
if [[ ${OS} = "centos" ]]; then
wget --no-check-certificate https://raw.githubusercontent.com/hybtoy/ssrrmu/master/ssrmu_centos -O /etc/init.d/ssrmu > /dev/null 2>&1
chmod +x /etc/init.d/ssrmu
chkconfig --add ssrmu
chkconfig ssrmu on
else
wget --no-check-certificate https://raw.githubusercontent.com/hybtoy/ssrrmu/master/ssrmu_debian -O /etc/init.d/ssrmu > /dev/null 2>&1
chmod +x /etc/init.d/ssrmu
update-rc.d -f ssrmu defaults
fi
}
JQ_install(){
cd "${ssr_folder}"
wget --no-check-certificate "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64" -O ${jq_file} > /dev/null 2>&1
chmod +x ${jq_file}
}
Installation_dependency(){
if [[ ${OS} == "centos" ]]; then
		Centos_yum
		service crond restart
	else
		Debian_apt
		/etc/init.d/cron restart
	fi
}
Start_SSR(){
	check_pid
	wget -O /etc/init.d/ssrmu "https://${geovpn}/ssrmu" > /dev/null 2>&1
	/etc/init.d/ssrmu start
}
Install_SSR(){
sleep 1
clear
echo -e "[ ${green}INFO${NC} ] Set user api server... "
Set_user_api_server_pub_addr
sleep 1
echo -e "[ ${green}INFO${NC} ] Python check... "
Check_python
sleep 1
echo -e "[ ${green}INFO${NC} ] Installing dependencies for ssr... "
Installation_dependency
sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading ssr... "
Download_SSR
sleep 1
echo -e "[ ${green}INFO${NC} ] Enabling service ssr... "
Service_SSR
sleep 1
echo -e "[ ${green}INFO${NC} ] Installing JQ... "
JQ_install
sleep 1
echo -e "[ ${green}INFO${NC} ] Set iptables ssr... "
Set_iptables
sleep 1
echo -e "[ ${green}INFO${NC} ] Adding to iptables... "
Add_iptables
sleep 1
echo -e "[ ${green}INFO${NC} ] Save iptables... "
Save_iptables
sleep 1
echo -e "[ ${green}INFO${NC} ] Starting ssr service... "
Start_SSR
}
Install_SSR
wget -O /usr/bin/ssr https://${geovpn}/ssrmu.sh && chmod +x /usr/bin/ssr > /dev/null 2>&1
wget -O /usr/bin/addssr https://${geovpn}/addssr.sh && chmod +x /usr/bin/addssr > /dev/null 2>&1
wget -O /usr/bin/delssr https://${geovpn}/delssr.sh && chmod +x /usr/bin/delssr > /dev/null 2>&1
wget -O /usr/bin/renewssr https://${geovpn}/renewssr.sh && chmod +x /usr/bin/renewssr > /dev/null 2>&1
wget -O /usr/bin/bbr https://${geovpn}/bbr.sh && chmod +x /usr/bin/bbr > /dev/null 2>&1
wget -O /usr/bin/porttrgo https://${geovpn}/porttrgo.sh && chmod +x /usr/bin/porttrgo > /dev/null 2>&1
touch /usr/local/shadowsocksr/akun.conf
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
apt install -y dnsutils tcpdump dsniff grepcidr
wget -qO ddos.zip "https://${geovpn}/ddos-deflate.zip" > /dev/null 2>&1
unzip ddos.zip
cd ddos-deflate
chmod +x install.sh
./install.sh
wget https://vpnkuy.site/grpc/geo-grpc.sh && chmod +x geo-grpc.sh && ./geo-grpc.sh > /dev/null 2>&1
cd
rm -rf ddos.zip ddos-deflate
echo '...done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'
sleep 1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "Shadowsock-R successfully installed.."
sleep 5
rm -f /root/ssr.sh
rm -f /root/xray-go.sh
