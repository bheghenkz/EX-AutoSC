#!/bin/bash

echo "[SSH][Step 1/4] Downloading EX-AutoSCs..."

curl -sS https://raw.githubusercontent.com/bheghenkz/EX-AutoSC/main/ssh/create.sh --output /usr/local/sbin/ssh-create-account
curl -sS https://raw.githubusercontent.com/bheghenkz/EX-AutoSC/main/ssh/renew.sh --output /usr/local/sbin/ssh-renew-account
curl -sS https://raw.githubusercontent.com/bheghenkz/EX-AutoSC/main/ssh/password.sh --output /usr/local/sbin/ssh-password-account
curl -sS https://raw.githubusercontent.com/bheghenkz/EX-AutoSC/main/ssh/delete.sh --output /usr/local/sbin/ssh-delete-account

echo "[SSH][Step 2/4] EX-AutoSCs has been successfully downloaded"

sleep 1

echo "[SSH][Step 3/4] Applying permission..."

chmod +x /usr/local/sbin/ssh-create-account
chmod +x /usr/local/sbin/ssh-renew-account
chmod +x /usr/local/sbin/ssh-password-account
chmod +x /usr/local/sbin/ssh-delete-account

echo "[SSH][Step 4/4] Permission has been successfully applied"
