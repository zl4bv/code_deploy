actions :install,
        :uninstall,
        :start,
        :stop,
        :restart,
        :enable,
        :disable

default_action [:install, :enable, :start]

attribute :http_proxy, kind_of: String, default: ENV['http_proxy']
attribute :installer_url, kind_of: String
attribute :version_url, kind_of: String
