#!/bin/bash

/usr/bin/sleep 1
/usr/bin/sudo /usr/bin/sed -i -r 's/^#?(PermitRootLogin|PasswordAuthentication) no/\1 yes/' /etc/ssh/sshd_config > /dev/null
/usr/bin/sleep 1
#printf 'PermitRootLogin yes' >> /etc/ssh/sshd_config
#sleep 1
/usr/bin/sudo /usr/bin/systemctl restart sshd
/usr/bin/sleep 1
