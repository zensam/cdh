#!/bin/bash
NODE_NAME=$1
DOMAIN_NAME=$2
TYPE=$3

/bin/echo "Setting hostnames to nodes by $TYPE"

if [[ $TYPE == "management" ]]; then
/bin/sleep 1
/bin/hostname $NODE_NAME.$DOMAIN_NAME
/bin/sleep 1
/bin/sed -i 's/^HOSTNAME.*/HOSTNAME='$NODE_NAME'.'$DOMAIN_NAME'/g' /etc/sysconfig/network
elif [[ $TYPE == "nodes" ]]; then
/bin/sleep 1
/bin/hostname $NODE_NAME.$DOMAIN_NAME
/bin/sleep 1
/bin/sed -i 's/^HOSTNAME.*/HOSTNAME='$NODE_NAME'.'$DOMAIN_NAME'/g' /etc/sysconfig/network
elif [[ $TYPE == "infrastructure" ]]; then
/usr/bin/sudo /bin/sleep 1
/usr/bin/sudo /bin/hostnamectl set-hostname $NODE_NAME.$DOMAIN_NAME
/usr/bin/sudo /bin/sleep 1
/usr/bin/sudo /bin/sed -i 's/^HOSTNAME.*/HOSTNAME='$NODE_NAME'.'$DOMAIN_NAME'/g' /etc/sysconfig/network
elif [[ $TYPE == "hub" ]]; then
/bin/sleep 1
/bin/hostname $NODE_NAME.$DOMAIN_NAME
/bin/sleep 1
/bin/sed -i 's/^HOSTNAME.*/HOSTNAME='$NODE_NAME'.'$DOMAIN_NAME'/g' /etc/sysconfig/network
else
  /bin/echo "'$TYPE' is not a valid CFEngine type."
fi
