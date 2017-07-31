resource_name :code_deploy_agent

default_action %i[install enable start]

provides :code_deploy_agent_windows
provides :code_deploy_agent, platform_family: 'windows'

action_class do
  include CodeDeploy::Helper
end

action :install do
  windows_package installer_url('msi')

  service 'codedeployagent' do
    action :nothing
    retries 2
  end
end

action :uninstall do
  windows_package installer_url('msi') do
    action :remove
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
    service 'codedeployagent' do
      action a
      retries 2
    end
  end
end
