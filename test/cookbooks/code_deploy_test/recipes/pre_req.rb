# The Centos-7.2 docker image has no /sbin/service
if node[:platform_family] == 'rhel'
  package 'initscripts'
end
