include_recipe 'python'
include_recipe "python::pip"

%w{selenium supervisor}.each do |list|
  python_pip list
end

%w[ /var/log/supervisor /etc/supervisor ].each do |path|
  directory path do
    owner 'root'
    group 'root'
    mode '0755'
  end
end

directory "/opt/cloudera/parcel-cache" do
  action :create
  recursive true
  owner "root"
  group "root"
end

template "/etc/supervisord.conf" do
  path "/etc/supervisord.conf"
  source "supervisord.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "/etc/supervisor/supervisord.conf" do
  path "/etc/supervisor/supervisord.conf"
  source "supervisord.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "/etc/init.d/supervisord" do
  path "/etc/init.d/supervisord"
  source "supervisord-initd.erb"
  owner "root"
  group "root"
  mode "0755"
end

link "/usr/local/bin/supervisord" do
  to "/usr/bin/supervisord"
end

link "/usr/local/etc/supervisord.conf" do
  to "/etc/supervisor/supervisord.conf"
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

template "/opt/clusteraconfig.txt" do
  path "/opt/clusteraconfig.txt"
  source "clusteraconfig.txt.erb"
  owner "root"
  group "root"
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

r = remote_file "#{node['cloudera_server']['phantom_js_file']}" do
  source node['cloudera_server']['phantom_js_url']
  action :create_if_missing
  checksum "a1d9628118e270f26c4ddd1d7f3502a93b48ede334b8585d11c1c3ae7bc7163a"
end

src_filepath = "/tmp"
src_filename = "phantomjs-1.9.8-linux-x86_64.tar.bz2"
extract_path = "/opt/phantomjs-1.9.8-linux-x86_64"

bash "extract files" do
  code <<-EOH
    tar --directory=/opt -jxf #{src_filepath}/#{src_filename}
    EOH
  action :nothing
  subscribes :run, r
end	

template "/root/ldap_external_auth.sql" do
  path "/root/ldap_external_auth.sql"
  source "ldap_external_auth.sql.erb"
  owner "root"
  group "root"
  mode "0644"
end

service "supervisord" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start]
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

%w{cloudera-manager-server cloudera-manager-agent cloudera-manager-daemons mysql-connector-java cloudera-manager-server-db-2 mysql-server expect}.each  do |list2|
  package list2
end

file "/var/run/postgresql" do
  mode "0775"
end

group 'postgres' do
  action :modify
  members 'cloudera-scm'
  append true
end  

directory "/opt/cloudera/parcel-repo" do
  action :create
  recursive true
  owner "cloudera-scm"
  group "cloudera-scm"
end

remote_file "Copy parcel file" do 
  path "/opt/cloudera/parcel-repo/CDH-5.3.6-1.cdh5.3.6.p0.11-el6.parcel" 
  source "file:///opt/cloudera/parcel-cache/CDH-5.3.6-1.cdh5.3.6.p0.11-el6.parcel"
end

remote_file "Copy parcel file" do 
  path "/opt/cloudera/parcel-repo/CDH-5.3.6-1.cdh5.3.6.p0.11-el6.parcel.sha1" 
  source "file:///opt/cloudera/parcel-cache/CDH-5.3.6-1.cdh5.3.6.p0.11-el6.parcel.sha1"
end

remote_file "Copy parcel file" do 
  path "/opt/cloudera/parcel-repo/CDH-5.3.6-1.cdh5.3.6.p0.11-el6.parcel.sha" 
  source "file:///opt/cloudera/parcel-cache/CDH-5.3.6-1.cdh5.3.6.p0.11-el6.parcel.sha"
end
  
service "cloudera-scm-server-db" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start]
end

service "cloudera-scm-server-db" do
  action [:stop]
end
  
template "/var/lib/cloudera-scm-server-db/data/pg_hba.conf" do
  path "/var/lib/cloudera-scm-server-db/data/pg_hba.conf"
  source "pg_hba.conf.erb"
  owner "cloudera-scm"
  group "cloudera-scm"
  mode "0600"
end

template "/etc/cloudera-scm-agent/config.ini" do
  path "/etc/cloudera-scm-agent/config.ini"
  source "cloudera-agent_config.ini.erb"
end

service "cloudera-scm-server" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :stop, :start]
end  

service "cloudera-scm-server-db" do
  action [:start]
end

service "iptables" do
  action [:stop]
end

service "cloudera-scm-agent" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start]
end
