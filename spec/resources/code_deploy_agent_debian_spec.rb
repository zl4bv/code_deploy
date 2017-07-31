require 'chefspec'
require 'chefspec/berkshelf'

describe 'code_deploy::install_agent' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '16.04',
      step_into: ['code_deploy_agent'],
      file_cache_path: '/tmp'
    ).converge(described_recipe)
  end

  let(:resp) { double('resp', body: { deb: 'releases/codedeploy-agent-VERSION.deb' }.to_json) }

  before do
    allow(Net::HTTP).to receive(:get_response).and_return(resp)
  end

  it 'installs ruby' do
    expect(chef_run).to install_package('ruby')
  end

  it 'downlads the deb' do
    expect(chef_run).to create_remote_file(
      '/tmp/code_deploy/codedeploy-agent-VERSION.deb'
    ).with(
      source: 'https://aws-codedeploy-us-east-1.s3.amazonaws.com/releases/codedeploy-agent-VERSION.deb'
    )
  end

  it 'installs the deb' do
    expect(chef_run).to install_dpkg_package(
      '/tmp/code_deploy/codedeploy-agent-VERSION.deb'
    )
  end
end
