require 'chefspec'
require 'chefspec/berkshelf'

describe 'code_deploy::install_agent' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'windows',
      version: '2012R2',
      step_into: ['code_deploy_agent']
    ).converge(described_recipe)
  end

  let(:resp) { double('resp', body: { msi: 'releases/codedeploy-agent-VERSION.msi' }.to_json) }

  before do
    allow(Net::HTTP).to receive(:get_response).and_return(resp)
  end

  it 'installs the msi' do
    expect(chef_run).to install_windows_package(
      'https://aws-codedeploy-us-east-1.s3.amazonaws.com/releases/codedeploy-agent-VERSION.msi'
    )
  end
end
