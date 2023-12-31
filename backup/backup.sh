#!/bin/bash
# HT Cloud
# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ==========================================
# Getting
clear
IP=$(wget -qO- ipinfo.io/ip);
date=$(date +"%Y-%m-%d")
clear
email=$(cat /home/email)
if [[ "$email" = "" ]]; then
echo "Masukkan Email Untuk Menerima Backup"
read -rp "Email : " -e email
cat <<EOF>>/home/email
$email
EOF
fi
clear
echo "Mohon Menunggu , Proses Backup sedang berlangsung !!"
    mkdir -p /root/backup
cp -r /etc/xray/config.json backup/ >/dev/null 2>&1
cp /etc/passwd backup/
cp /etc/group backup/
cp /etc/shadow backup/
cp /etc/gshadow backup/
cp -r /var/www/html backup/html
cd /root
zip -r $IP-$date.zip backup > /dev/null 2>&1
rclone copy /root/$IP-$date.zip dr:backup/
url=$(rclone link dr:backup/$IP-$date.zip)
id=(`echo $url | grep '^https' | cut -d'=' -f2`)
link="https://drive.google.com/u/4/uc?id=${id}&export=download"
echo -e "
Detail Backup 
echo -e " ================================== " | lolcat
echo -e " IP VPS        : $IP " | lolcat
echo -e " Link Backup   : $link " | lolcat
echo -e " Tanggal       : $date " | lolcat
echo -e " ================================== " | lolcat
" | mail -s "Backup Data" $email
rm -rf /root/backup
rm -r /root/$IP-$date.zip
clear
echo -e "
Detail Backup 
echo -e " ================================== " | lolcat
echo -e " IP VPS        : $IP " | lolcat
echo -e " Link Backup   : $link " | lolcat
echo -e " Tanggal       : $date " | lolcat
echo -e " ================================== " | lolcat
"
echo "Silahkan cek Kotak Masuk $email"
