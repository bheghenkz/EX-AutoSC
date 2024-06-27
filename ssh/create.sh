#!/bin/bash
source /usr/local/sbin/spiner
source /usr/local/sbin/send-bot

USERNAME=$1
PASSWORD=$2
EXPIRED_AT=$3
IPLIMIT="2"

IP=$(curl -s ipv4.icanhazip.com)
if [[ "$IP" = "" ]]; then
    DOMAIN=$(cat /etc/xray/domain)
else
    DOMAIN=$IP
fi

if [[ $IPLIMIT -gt 0 ]]; then
mkdir -p /etc/kyt/limit/ssh/ip
echo -e "$IPLIMIT" > /etc/kyt/limit/ssh/ip/$USERNAME
else
echo > /dev/null
fi

useradd -e "${EXPIRED_AT}" -s /bin/false -M "${USERNAME}" &> /dev/null

echo -e "${PASSWORD}\n${PASSWORD}\n" | passwd "${USERNAME}" &> /dev/null

DATADB=$(cat /etc/ssh/.ssh.db | grep "^#ssh#" | grep -w "${USERNAME}" | awk '{print $2}')
if [[ "${DATADB}" != '' ]]; then
  sed -i "/\b${USERNAME}\b/d" /etc/ssh/.ssh.db
fi
echo "#ssh# ${USERNAME} ${PASSWORD} ${IPLIMIT} ${EXPIRED_AT}" >>/etc/ssh/.ssh.db
clear

#kirim Bot
if [ ! -e /etc/active ]; then
  mkdir -p /etc/active
fi

if [ -e "/etc/active/1-ssh" ]; then
    send_ssh
else
    echo -e ""
fi

clear
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "            SSH Account"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Username    : ${USERNAME}"
echo "Password    : ${PASSWORD}"
echo "Expired On  : ${EXPIRED_AT}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "IP               : ${IP}"
echo "Host             : ${DOMAIN}"
echo "Port OpenSSH     : 443, 80, 22"
echo "Port SSH UDP     : 1-65535"
echo "Port Dropbear    : 443, 109"
echo "Port SSH WS      : 80, 8080, 8081-9999"
echo "Port SSH SSL WS  : 443"
echo "Port SSL/TLS     : 400-900"
echo "Port OVPN WS SSL : 443"
echo "Port OVPN SSL    : 443"
echo "Port OVPN TCP    : 443, 1194"
echo "Port OVPN UDP    : 2200"
echo "BadVPN UDP       : 7100, 7300, 7300"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "OVPN Download    : https://$DOMAIN:81/"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Payload WSS"
echo "GET wss://isi_bug_disini HTTP/1.1[crlf]Host: ${DOMAIN}[crlf]Upgrade: websocket[crlf][crlf]"
echo "Payload WS"
echo "GET / HTTP/1.1[crlf]Host: ${DOMAIN}[crlf]Upgrade: websocket[crlf][crlf]"
