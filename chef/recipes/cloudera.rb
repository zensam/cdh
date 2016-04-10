include_recipe 'python'
include_recipe 'python::pip'

template "/etc/sysctl.conf" do
  path "/etc/sysctl.conf"
  source "sysctl.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

remote_file "Copy timezone file" do 
  path "/etc/localtime" 
  source "file:///usr/share/zoneinfo/UTC"
  owner 'root'
  group 'root'
  mode 0644
end

template "/etc/yum.repos.d/epel.repo" do
  path "/etc/yum.repos.d/epel.repo"
  source "epel.repo.erb"
  owner "root"
  group "root"
  mode "0644"
end

execute 'update system' do
  command 'yum -y update'
end

file "/root/.ssh/authorized_keys" do
  action :delete
end

%w{openssh-server openssh-clients tar unzip vim wget krb5-libs krb5-workstation net-tools ntp openldap-clients python-pip}.each  do |list|
  package list
end

python_pip "cm_api" do
  version "9.0.0"
end

download_java_path = "/tmp/jdk-7u79-linux-x64.rpm"
bash "download java " do
  code <<-EOH
    wget -O /tmp/jdk-7u79-linux-x64.rpm --no-check-certificate -q -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.rpm
    EOH
  not_if { ::File.exists?(download_java_path) }
end

rpm_package "/tmp/jdk-7u79-linux-x64.rpm" do
  action :install
end

file "/tmp/jdk-7u79-linux-x64.rpm" do
  action :delete
end

remote_file "/tmp/UnlimitedJCEPolicyJDK7.zip" do
  source "https://s3-eu-west-1.amazonaws.com/<mycompany-aws-resource>-ireland/UnlimitedJCEPolicyJDK7.zip"
  action :create_if_missing
end

path_policy = "/tmp/UnlimitedJCEPolicy"
execute 'extract_policy_zip' do
  command 'unzip /tmp/UnlimitedJCEPolicyJDK7.zip -d /tmp'
  not_if { File.exists?(path_policy) }
end

file "/usr/java/jdk1.7.0_79/jre/lib/security/US_export_policy.jar" do
  action :delete
end

remote_file "Copy jar file" do 
  path "/usr/java/jdk1.7.0_79/jre/lib/security/US_export_policy.jar" 
  source "file:///tmp/UnlimitedJCEPolicy/US_export_policy.jar"
end

file "/usr/java/jdk1.7.0_79/jre/lib/security/local_policy.jar" do
  action :delete
end

remote_file "Copy local_jar file" do 
  path "/usr/java/jdk1.7.0_79/jre/lib/security/local_policy.jar" 
  source "file:///tmp/UnlimitedJCEPolicy/local_policy.jar"
end

file "/tmp/UnlimitedJCEPolicyJDK7.zip" do
  action :delete
end

directory "/tmp/UnlimitedJCEPolicy" do
  action :delete
  recursive true
end

execute "install_alt_java" do
  command "alternatives --install /usr/bin/java java /usr/lib/jvm/jre-1.7.0/bin/java 3"
  action :run
end

execute "set_alt_java" do
  command "alternatives --set java /usr/lib/jvm/jre-1.7.0/bin/java"
  action :run
end

cloudera_server_key "RPM-GPG-KEY-cloudera" do
  url "http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera"
  action :add
end

template "/etc/yum.repos.d/cloudera-manager.repo" do
  path "/etc/yum.repos.d/cloudera-manager.repo"
  source "cloudera-manager.repo.erb"
  owner "root"
  group "root"
  mode "0644"
end

%w{cloudera-manager-agent cloudera-manager-daemons mysql-connector-java}.each  do |list1|
  package list1
end

directory "/opt/cloudera/parcel-cache" do
  action :create
  recursive true
  owner "root"
  group "root"
end

remote_file "/opt/cloudera/parcel-cache/CDH-5.3.6-1.cdh5.3.6.p0.11-el6.parcel" do
  source "http://archive.cloudera.com/cdh5/parcels/5.3.6.11/CDH-5.3.6-1.cdh5.3.6.p0.11-el6.parcel"
  action :create_if_missing
  owner "root"
  group "root"
  mode "0644"
  retries 20
end

remote_file "/opt/cloudera/parcel-cache/CDH-5.3.6-1.cdh5.3.6.p0.11-el6.parcel.sha1" do
  source "http://archive.cloudera.com/cdh5/parcels/5.3.6.11/CDH-5.3.6-1.cdh5.3.6.p0.11-el6.parcel.sha1"
  action :create_if_missing
  owner "root"
  group "root"
  mode "0644"
end

remote_file "/opt/cloudera/parcel-cache/CDH-5.3.6-1.cdh5.3.6.p0.11-el6.parcel.sha" do
  source "http://archive.cloudera.com/cdh5/parcels/5.3.6.11/CDH-5.3.6-1.cdh5.3.6.p0.11-el6.parcel.sha1"
  action :create_if_missing
  owner "root"
  group "root"
  mode "0644"
end

file "/root/.ssh/authorized_keys" do
  action :delete
end

directory "/root/.ssh" do
  action :create
  owner "root"
  group "root"
  mode 0755
end

template "/root/.ssh/authorized_keys" do
  path "/root/.ssh/authorized_keys"
  source "authorized_keys.erb"
  owner "root"
  group "root"
end

template "/root/.ssh/config" do
  path "/root/.ssh/config"
  source "config_ssh.erb"
  owner "root"
  group "root"
end

template "/root/.ssh/id_rsa" do
  path "/root/.ssh/id_rsa"
  source "id_rsa.erb"
  owner "root"
  group "root"
  mode 0600
end

template "/etc/cloudera-scm-agent/config.ini" do
  path "/etc/cloudera-scm-agent/config.ini"
  source "cloudera-agent_config.ini.erb"
end

service "iptables" do
  action [:stop]
end

service "cloudera-scm-agent" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start]
end
