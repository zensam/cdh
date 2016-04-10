#!/bin/bash
TYPE=$1

if [[ $TYPE == "management" ]]; then
/bin/sleep 1
#/bin/sed -i -r 's/^#?(PermitRootLogin|PasswordAuthentication) no/\1 yes/' /etc/ssh/sshd_config > /dev/null
#/usr/bin/printf 'PermitRootLogin yes' >> /etc/ssh/sshd_config
#sleep 1
#/sbin/service sshd restart

elif [[ $TYPE == "nodes" ]]; then
/bin/sleep 1
#/bin/sed -i -r 's/^#?(PermitRootLogin|PasswordAuthentication) no/\1 yes/' /etc/ssh/sshd_config > /dev/null
#/usr/bin/printf 'PermitRootLogin yes' >> /etc/ssh/sshd_config
#sleep 1
#/sbin/service sshd restart

elif [[ $TYPE == "infrastructure" ]]; then
/bin/sleep 1
/usr/bin/sudo /bin/sed -i -r 's/^#?(PermitRootLogin|PasswordAuthentication) no/\1 yes/' /etc/ssh/sshd_config > /dev/null
/bin/sleep 1
/usr/bin/sudo /usr/bin/printf 'PermitRootLogin yes' >> /etc/ssh/sshd_config
/bin/sleep 1
/usr/bin/sudo /bin/systemctl restart sshd

elif [[ $TYPE == "hub" ]]; then
/bin/sleep 1
#/bin/sed -i -r 's/^#?(PermitRootLogin|PasswordAuthentication) no/\1 yes/' /etc/ssh/sshd_config > /dev/null
#/usr/bin/printf 'PermitRootLogin yes' >> /etc/ssh/sshd_config
#sleep 1
#/sbin/service sshd restart

else
  /bin/echo "'$TYPE' is not a valid CFEngine type."
fi


