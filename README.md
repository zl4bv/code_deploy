[![Build Status](https://travis-ci.org/meringu/code_deploy.svg?branch=master)](https://travis-ci.org/meringu/code_deploy)
[![Windows Status](https://ci.appveyor.com/api/projects/status/3521roy83j836c9s?svg=true)](https://ci.appveyor.com/project/meringu/code-deploy)
[![Cookbook](https://img.shields.io/cookbook/v/code_deploy.svg)](https://supermarket.chef.io/cookbooks/code_deploy)

# CodeDeploy cookbook

This cookbook allow you to install and manage the AWS CodeDeploy agent

## Requirements

Any version of Linux or Windows supported by CodeDeploy

## Usage

### Recipes

#### default

Installs, enables, and starts the CodeDeploy agent.

#### disable_agent

Disables the CodeDeploy agent

#### enable_agent

Enables the CodeDeploy agent

#### install_agent

Installs the CodeDeploy agent

#### restart_agent

Restarts the CodeDeploy agent

#### start_agent

Starts the CodeDeploy agent

#### stop_agent

Stops the CodeDeploy agent

#### uninstall_agent

Uninstalls the CodeDeploy agent

### Resources and Providers

#### code_deploy_agent

Use the `code_deploy_agent` resource to manage the CodeDeploy agent, all
attributes are optional.

```ruby
codedeploy-agent 'Install and start' do
  http_proxy ENV['http_proxy'] # default
  installer_url 'https://mycache/installer' # use an alternate installer
  version_url 'https://mycache/version' # version manifest for the installer_url
  action [:install, :enable, :start] # default, also supports:
                                     #  :disable
                                     #  :restart
                                     #  :stop
                                     #  :uninstall
end
```

## Contributing

  1. Fork it
  2. Create your feature branch (git checkout -b my-new-feature)
  3. Commit your changes (git commit -am 'Add some feature')
  4. Push to the branch (git push origin my-new-feature)
  5. Create new Pull Request

## See Also


## License & Authors

Author: Henry Muru Paenga (meringu@gmail.com)

```
Copyright 2016 Henry Muru Paenga <meringu@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
