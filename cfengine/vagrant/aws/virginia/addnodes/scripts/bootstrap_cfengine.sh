#!/bin/bash
if [[ ! -f /var/cfengine/policy_server.dat ]]; then
    /bin/echo -n "Bootstrapping to '$1'"
    /usr/bin/sudo /var/cfengine/bin/cf-agent --bootstrap $1 && echo "     [OK]"
fi
if [[ -f /var/cfengine/inputs/promises.cf ]]; then
    /bin/echo -n "Activating update policy"
    /usr/bin/sudo /var/cfengine/bin/cf-agent -f update.cf &> /dev/null&& echo "     [OK]"
    /bin/echo -n "Activating main policy"
    /usr/bin/sudo /var/cfengine/bin/cf-agent &> /dev/null&& echo "     [OK]"
fi
# To get the hub to show itself more quickly in the UI we go ahead and perform
# a collection
if [[ -x /var/cfengine/bin/cf-hub ]]; then
    /var/cfengine/bin/cf-hub --query rebase --query-host $1 &> /dev/null
    /bin/echo "Installing cron job to scan for new hosts and populate Mission Portal more quickly."
    /bin/echo "* * * * * root /bin/bash /vagrant/scripts/quickhub.sh" > /etc/cron.d/quickhub
fi
exit 0
