#!/bin/bash

USERNAME=$1

userdel "${USERNAME}" &> /dev/null

rm -rf /etc/kyt/limit/ssh/ip/$USERNAME
rm -irf /var/www/html/ssh-$USERNAME.txt