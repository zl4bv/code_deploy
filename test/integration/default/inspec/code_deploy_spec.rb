control 'CodeDeploy' do
  impact 1.0
  title 'Installing the CodeDeploy Agent'
  desc '
    When the CodeDeploy Agent is installed the service should be installed and
    running
  '

  if os.windows?
    describe service('codedeployagent') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end

    describe file('C:/ProgramData/Amazon/CodeDeploy/conf.yml') do
      it { should exist }
    end
  else
    describe service('codedeploy-agent') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end

    describe file('/etc/cron.d/codedeploy-agent-update') do
      it { should_not exist }
    end

    describe file('/etc/codedeploy-agent/conf/codedeployagent.yml') do
      it { should exist }
    end
  end
end
