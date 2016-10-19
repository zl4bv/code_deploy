name             'code_deploy'
maintainer       'Henry Muru Paenga'
maintainer_email 'meringu@gmail.com'
license          'Apache v2.0'
description      'Installs and configures CodeDeploy'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.3'

supports         'Amazon'
supports         'rhel'
supports         'ubuntu'

source_url 'https://github.com/meringu/code_deploy' if respond_to?(:source_url)
issues_url 'https://github.com/meringu/code_deploy/issues' if respond_to?(:issues_url)

depends 'apt'
