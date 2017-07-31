name             'code_deploy'
maintainer       'Henry Muru Paenga'
maintainer_email 'meringu@gmail.com'
license          'Apache-2.0'
description      'Installs Amazon CodeDeploy agent'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
chef_version     '>= 12.5'
version          '1.0.0'

supports         'Amazon'
supports         'rhel'
supports         'ubuntu'
supports         'windows'

source_url       'https://github.com/meringu/code_deploy' if respond_to?(:source_url)
issues_url       'https://github.com/meringu/code_deploy/issues' if respond_to?(:issues_url)

depends          'apt'
