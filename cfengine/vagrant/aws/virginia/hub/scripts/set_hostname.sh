#!/bin/bash
NODE_NAME=$1
DOMAIN_NAME=$2


/bin/sleep 3
/bin/hostname $NODE_NAME.$DOMAIN_NAME
/bin/sleep 3
/bin/sed -i 's/^HOSTNAME.*/HOSTNAME='$NODE_NAME'.'$DOMAIN_NAME'/g' /etc/sysconfig/network
/bin/echo -e 