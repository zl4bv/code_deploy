resource_name :code_deploy_agent

default_action %i[install enable start]

provides :code_deploy_agent_linux
provides :code_deploy_agent, platform_family: 'rhel'

property :auto_update, [true, false], default: false

action_class do
  include CodeDeploy::Helper
end

action :install do
  package 'ruby'

  download_installer_to_cache('rpm')

  package installer_cache_path('rpm')

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
    action :remove

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
