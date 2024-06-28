#!/bin/bash

USERNAME=$1
EXPIRED_AT=$2

sed -i "/### ${USERNAME}/c\### ${USERNAME} ${EXPIRED_AT}" /etc/xray/config.json
sed -i "/### ${USERNAME}/c\### ${USERNAME} ${USERNAME}" /etc/vmess/.vmess.db

systemctl restart xray > /dev/null 2>&1
