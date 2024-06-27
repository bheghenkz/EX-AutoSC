#!/bin/bash

USERNAME=$1
EXPIRED_AT=$2

IP=$(curl -s ipv4.icanhazip.com)
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
DOMAIN=$(cat /etc/xray/domain)



# shellcheck disable=SC2002
TLS="443"
# shellcheck disable=SC2002
NTLS="80"
UUID=$(cat /proc/sys/kernel/random/uuid)
TROJAN_LINK_TLS="trojan://${UUID}@isi_bug_disini:${TLS}?path=%2Ftrojan-ws&security=tls&host=${DOMAIN}&type=ws&sni=${DOMAIN}#${USERNAME}"
TROJAN_LINK_GRPC="trojan://${UUID}@${DOMAIN}:${TLS}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=bug.com#${USERNAME}"
TROJAN_LINK_NTLS="trojan://${UUID}@isi_bug_disini:${NTLS}?path=%2Ftrojan-ws&security=none&host=${DOMAIN}&type=ws#${USERNAME}"

# shellcheck disable=SC2027
# shellcheck disable=SC2086
# shellcheck disable=SC1004
sed -i '/#trojanws$/a\#! '"$USERNAME $EXPIRED_AT"'\
},{"password": "'""${UUID}""'","email": "'""${USERNAME}""'"' /etc/xray/config.json
# shellcheck disable=SC2027
# shellcheck disable=SC2086
# shellcheck disable=SC1004
sed -i '/#trojangrpc$/a\#! '"$USERNAME $EXPIRED_AT"'\
},{"password": "'""${UUID}""'","email": "'""${USERNAME}""'"' /etc/xray/config.json


systemctl restart xray > /dev/null 2>&1

cat >/var/www/html/trojan-$USERNAME.txt <<-END
=========================
   SmileVPN Tunneling 
=========================

# Format Trojan GO/WS

- name: $USERNAME
  server: ${DOMAIN}
  port: 443
  type: trojan
  password: ${UUID}
  network: ws
  sni: ${DOMAIN}
  skip-cert-verify: true
  udp: true
  ws-opts:
    path: /trojan-ws
    headers:
  Host: ${DOMAIN}

# Format Trojan gRPC

- name: $USERNAME
  type: trojan
  server: ${DOMAIN}
  port: 443
  password: ${UUID}
  udp: true
  sni: ${DOMAIN}
  skip-cert-verify: true
  network: grpc
  grpc-opts:
    grpc-service-name: trojan-grpc
END


echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "           TROJAN ACCOUNT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Remarks       : ${USERNAME}"
echo "Host/IP       : ${DOMAIN}"
#echo "User Quota    : ${Quota1}"
#echo "User Ip       : ${IPLIMIT} IP"
echo "Wildcard      : (bug.com).${DOMAIN}"
echo "Port TLS      : ${TLS}"
echo "Port none TLS : ${NTLS}"
echo "Port gRPC     : ${TLS}"
echo "Key           : ${UUID}"
echo "Path          : /trojan-ws"
echo "Dynamic       : https://bugmu.com/path"
echo "ServiceName   : trojan-grpc"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "OpenClash     : https://${DOMAIN}:81/trojan-$USERNAME.txt" 
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Link TLS      : ${TROJAN_LINK_TLS}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Link none TLS : ${TROJAN_LINK_NTLS}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Link gRPC     : ${TROJAN_LINK_GRPC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Expired At    : ${EXPIRED_AT} "
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
