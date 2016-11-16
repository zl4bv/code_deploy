control 'CodeDeploy' do
  impact 1.0
  title 'Installing the CodeDeploy Agent'
  desc '
    When the CodeDeploy Agent is installed the service should be installed and
    running
  '

  describe service('codedeploy-agent') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/cron.d/codedeploy-agent-update') do
    it { should_not exist }
  end
end
