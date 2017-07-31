resource_name :code_deploy_agent

default_action %i[install enable start]

provides :code_deploy_agent_linux
provides :code_deploy_agent, platform_family: 'debian'

property :auto_update, [true, false], default: false

action_class do
  include CodeDeploy::Helper
end

action :install do
  include_recipe 'apt'

  package 'ruby' do
    package_name 'ruby2.0' if ubuntu_less_than_15?
  end

  download_installer_to_cache('deb')

  dpkg_package installer_cache_path('deb')

  service 'codedeploy-agent' do
    action :nothing
    retries 2
  end

  file '/etc/cron.d/codedeploy-agent-update' do
    action :delete

    not_if { new_resource.auto_update }
  end
end

action :uninstall do
  execute 'systemctl daemon-reload' do
    only_if { systemd? }

    action :nothing
  end

  package 'codedeploy-agent' do
    action :purge

    notifies :run, 'execute[systemctl daemon-reload]'
  end
end

%i[
  disable
  enable
  restart
  start
  stop
].each do |a|
  action a do
    service 'codedeploy-agent' do
      action a
      retries 2
    end
  end
end
