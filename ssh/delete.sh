#!/bin/bash

USERNAME=$1

userdel "${USERNAME}" &> /dev/null

rm -rf /etc/kyt/limit/ssh/ip/$USERNAME