#!/bin/bash
TYPE=$1
PACKAGE_RELEASE=$2
PACKAGE_BUILD=$3


echo "Checking for CFEngine Enterprise $TYPE"
if [[ $TYPE == "management" ]]; then
    if $(/bin/rpm --query --quiet cfengine-nova); then
        echo "CFEngine Enterprise for group $TYPE is already installed"
    else
        echo "Installing CFEngine Enterprise $TYPE"
        rpm -i http://cfengine.package-repos.s3.amazonaws.com/enterprise/Enterprise-3.6.5/agent/agent_rpm_x86_64/cfengine-nova-3.6.5-1.x86_64.rpm
    fi
elif [[ $TYPE == "nodes" ]]; then
    if $(/bin/rpm --query --quiet cfengine-nova); then
        echo "CFEngine Enterprise for group $TYPE is already installed"
    else
        echo "Installing CFEngine Enterprise $TYPE"
        rpm -i http://cfengine.package-repos.s3.amazonaws.com/enterprise/Enterprise-3.6.5/agent/agent_rpm_x86_64/cfengine-nova-3.6.5-1.x86_64.rpm
    fi
elif [[ $TYPE == "infrastructure" ]]; then
    if $(/bin/rpm --query --quiet cfengine-nova); then
        echo "CFEngine Enterprise for group $TYPE is already installed"
    else
        echo "Installing CFEngine Enterprise $TYPE"
        rpm -i rpm -i http://cfengine.package-repos.s3.amazonaws.com/enterprise/Enterprise-3.6.5/agent/agent_rhel7_x86_64/cfengine-nova-3.6.5-1.x86_64.rpm
    fi

elif [[ $TYPE == "hub" ]]; then
    if $(/bin/rpm --query --quiet cfengine-nova-hub); then
        echo "CFEngine Enterprise $TYPE is already installed"
    else
        echo "Installing CFEngine Enterprise $TYPE"
        /bin/rpm -i http://cfengine.package-repos.s3.amazonaws.com/enterprise/Enterprise-3.6.5/hub/redhat_6_x86_64/cfengine-nova-hub-3.6.5-1.x86_64.rpm
    fi
else
  echo "'$TYPE' is not a valid CFEngine package type."
fi
