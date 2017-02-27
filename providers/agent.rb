require 'chef/version_constraint'

include ::Chef::Mixin::ShellOut

use_inline_resources

def whyrun_supported?
  true
end

def up_to_date
  ![0, nil].include?(/#{current_version}/ =~ upstream_version)
end

def current_version
  case node['platform_family']
  when 'rhel'
    cmd = shell_out('rpm -q codedeploy-agent')
    if cmd.error?
      nil
    else
      cmd.stdout
    end
  when 'debian'
    cmd = shell_out('dpkg -s codedeploy-agent')
    if cmd.error?
      nil
    else
      running_agent_info = cmd.stdout.split
      version_index = running_agent_info.index('Version:')
      running_agent_info[version_index + 1]
    end
  else
    raise "#{node['platform_family']} not supported"
  end
end

def upstream_version
  uri = URI.parse(version_url)
  response = Net::HTTP.get_response(uri)
  versions = JSON.parse(response.body)

  package_type = {
    'debian' => 'deb',
    'rhel' => 'rpm',
    'windows' => 'msi'
  }[node['platform_family']]

  versions[package_type]
end

def region
  if node.key?('ec2')
    node['ec2']['placement_availability_zone'][0..-2]
  else
    'us-east-1'
  end
end

def bucket
  "aws-codedeploy-#{region}"
end

def service_name
  if node['platform'] == 'windows'
    'codedeployagent'
  else
    'codedeploy-agent'
  end
end

def package_name
  'codedeploy-agent'
end

def installer_file
  if node['platform'] == 'windows'
    'codedeploy-agent.msi'
  else
    'install'
  end
end

def installer_url
  new_resource.installer_url || "https://#{bucket}.s3.amazonaws.com/latest/#{installer_file}"
end

def version_url
  new_resource.version_url || "https://#{bucket}.s3.amazonaws.com/latest/VERSION"
end

def installer_path
  "#{Chef::Config[:file_cache_path]}/code_deploy/#{installer_file}"
end

def install_ruby
  include_recipe 'apt'

  if node['platform'] == 'ubuntu' &&
     Chef::VersionConstraint.new('< 15.0').include?(node['platform_version'])
    package 'ruby2.0'
  else
    package 'ruby'
  end
end

def install_code_deploy_agent
  if node['platform'] == 'windows'
    windows_package installer_url
  else
    install_ruby

    directory ::File.dirname(installer_path)

    remote_file installer_path do
      source installer_url
      mode '0755'
      sensitive true
      not_if { up_to_date }
    end

    proxy_arg = "--proxy #{new_resource.http_proxy}" unless new_resource.http_proxy.nil?

    execute 'Install CodeDeploy agent' do
      command [installer_path, proxy_arg, 'auto'].compact.join(' ')
      not_if { up_to_date }
    end

    file '/etc/cron.d/codedeploy-agent-update' do
      action :delete
    end
  end
end

def systemd?
  cmd = shell_out('systemctl | grep "\-\.mount"')
  !cmd.error?
end

action :install do
  install_code_deploy_agent
end

action :uninstall do
  case node['platform_family']
  when 'debian'
    dpkg_package package_name do
      action :purge
    end
  when 'windows'
    package installer_url do
      action :remove
    end
  else
    package package_name do
      action :remove
    end
  end

  # systemd isn't reloaded after RPM removes the service unit from disk
  execute 'Reload systemd' do
    command 'systemctl daemon-reload'
    only_if { systemd? }
  end
end

%i(
  disable
  enable
  restart
  start
  stop
).each do |a|
  action a do
    service service_name do
      action a
      retries 2
    end
  end
end
