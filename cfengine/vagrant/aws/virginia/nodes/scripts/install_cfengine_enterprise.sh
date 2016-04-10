#!/bin/bash
TYPE=$1
#RPMURL7=http://ec2-52-17-243-243.eu-west-1.compute.amazonaws.com/dist/rhel7/cfengine-nova-3.6.5-1.x86_64.rpm
#RPMURL6=http://ec2-52-17-243-243.eu-west-1.compute.amazonaws.com/dist/rhel6/cfengine-nova-3.6.5-1.x86_64.rpm
RPMURL7=http://cfengine.package-repos.s3.amazonaws.com/enterprise/Enterprise-3.6.5/agent/agent_rhel7_x86_64/cfengine-nova-3.6.5-1.x86_64.rpm
RPMURL6=http://cfengine.package-repos.s3.amazonaws.com/enterprise/Enterprise-3.6.5/agent/agent_rpm_x86_64/cfengine-nova-3.6.5-1.x86_64.rpm
RPMULHUB=http://cfengine.package-repos.s3.amazonaws.com/enterprise/Enterprise-3.6.5/hub/redhat_6_x86_64/cfengine-nova-hub-3.6.5-1.x86_64.rpm

/bin/echo "Checking for CFEngine Enterprise $TYPE"

if [[ $TYPE == "management" ]]; then
    if $(/bin/rpm --query --quiet cfengine-nova); then
        /bin/echo "CFEngine Enterprise for group $TYPE is already installed"
    else
        /bin/echo "Installing CFEngine Enterprise $TYPE"
        /bin/rpm -i $RPMURL6
    fi
elif [[ $TYPE == "nodes" ]]; then
    if $(/bin/rpm --query --quiet cfengine-nova); then
        /bin/echo "CFEngine Enterprise for group $TYPE is already installed"
    else
        /bin/echo "Installing CFEngine Enterprise $TYPE"
        /bin/rpm -i $RPMURL6
    fi
elif [[ $TYPE == "infrastructure" ]]; then
    if $(/usr/bin/sudo /bin/rpm --query --quiet cfengine-nova); then
        /usr/bin/sudo /bin/echo "CFEngine Enterprise for group $TYPE is already installed"
    else
        /usr/bin/sudo /bin/echo "Installing CFEngine Enterprise $TYPE"
        /usr/bin/sudo /bin/rpm -i $RPMURL6
    fi

elif [[ $TYPE == "hub" ]]; then
    if $(/bin/rpm --query --quiet cfengine-nova-hub); then
        /bin/echo "CFEngine Enterprise $TYPE is already installed"
    else
        /bin/echo "Installing CFEngine Enterprise $TYPE"
        /bin/rpm -i $RPMULHUB
    fi
else
  /bin/echo "'$TYPE' is not a valid CFEngine package type."
fi
