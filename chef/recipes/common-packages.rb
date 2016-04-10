package "epel-release" do
  action :install
end

template "/etc/yum.repos.d/epel.repo" do
  path "/etc/yum.repos.d/epel.repo"
  source "epel.repo.erb"
  owner "root"
  group "root"
  mode "0644"
end

%w{bind-utils bzip2 curl expect krb5-libs krb5-workstation lsof net-tools nmap ntp openldap-clients openssh-server openssh-clients psmisc python-pip python-setuptools sudo sysstat tmux tar unzip vim-common wget e2fsprogs libstdc++ vim libselinux-python git supervisor}.each  do |list|
  package list
end