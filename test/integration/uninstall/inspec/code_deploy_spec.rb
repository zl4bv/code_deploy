control 'CodeDeploy' do
  impact 1.0
  title 'Uninstalling the CodeDeploy Agent'
  desc '
    When the CodeDeploy Agent is installed the service should be installed and
    stopped
  '

  if os.windows?
    describe service('codedeployagent') do
      it { should_not be_installed }
    end
  else
    describe service('codedeploy-agent') do
      it { should_not be_installed }
    end
  end
end
