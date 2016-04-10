#!/bin/bash
NODE_NAME=$1
DOMAIN_NAME=$2

/usr/bin/sleep 3
#/usr/bin/sudo /usr/bin/hostname $NODE_NAME.$DOMAIN_NAME
/usr/bin/sudo /bin/hostnamectl set-hostname $NODE_NAME.$DOMAIN_NAME
/usr/bin/sleep 3
/usr/bin/sed -i 's/^HOSTNAME.*/HOSTNAME='$NODE_NAME'.'$DOMAIN_NAME'/g' /etc/sysconfig/network
#/usr/bin/sleep 3
#/usr/bin/printf $NODE_NAME'.'$DOMAIN_NAME'\n' > /etc/hostname
