#!/bin/bash
IP=192.168.18.5
ROOT_PASSWORD=""

echo -n "Enter root password: "
read -s ROOT_PASSWORD
echo ""

# ssh-keygen -R $IP

sshpass -p $ROOT_PASSWORD scp -r ../my-archlinux/* root@$IP:/tmp
sshpass -p $ROOT_PASSWORD ssh root@$IP "chmod +x /tmp/arch_install.sh"
sshpass -p $ROOT_PASSWORD ssh root@$IP "/tmp/arch_install.sh"