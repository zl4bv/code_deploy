module CodeDeploy
  # Helper methods for the code_deploy_agent resourse
  #
  module Helper
    # The nearest CodeDeploy S3 bucket to the machine. Defaults to the standard
    # region if not in ec2
    #
    # @return [String]
    #
    def code_deploy_bucket
      region = if node.key?('ec2')
                 node['ec2']['placement_availability_zone'].chop
               else
                 'us-east-1'
               end
      "aws-codedeploy-#{region}"
    end

    # Https url to an object in the CodeDeploy S3 bucket
    #
    # @param prefix [String] The prefix in the bucket
    #
    # @return [String] The url of the item in the bucket
    #
    def https_code_deploy_bucket_loc(prefix)
      "https://#{code_deploy_bucket}.s3.amazonaws.com/#{prefix}"
    end

    # Creates Chef resources to download the instaler to the
    # +#installer_cache_path+
    #
    # @param [String] one of 'rpm', 'deb', or 'msi'
    #
    def download_installer_to_cache(package_type)
      directory ::File.dirname(installer_cache_path(package_type)) do
        recursive true
      end

      remote_file installer_cache_path(package_type) do
        source installer_url(package_type)
      end
    end

    # Hash of the latest versions of the CodeDeploy agent.
    #
    # @return [Hash]
    #
    # @example
    #   version_hash
    #    => {
    #         "rpm": "releases/codedeploy-agent-VERSION.noarch.rpm",
    #         "deb": "releases/codedeploy-agent_VERSION_all.deb",
    #         "msi": "releases/codedeploy-agent-VERSION.msi"
    #       }
    #
    def version_hash
      @version_hash ||= begin
        uri = URI.parse(https_code_deploy_bucket_loc('latest/VERSION'))
        response = Net::HTTP.get_response(uri)
        JSON.parse(response.body)
      end
    end

    # Url of the installer package
    #
    # @param [String] one of 'rpm', 'deb', or 'msi'
    #
    def installer_url(package_type)
      https_code_deploy_bucket_loc(version_hash[package_type])
    end

    # Path in the cache to the installer once the resources from
    # +download_installer_to_cache+ have converged
    #
    # @param [String] one of 'rpm', 'deb', or 'msi'
    #
    def installer_cache_path(package_type)
      file_name = ::File.basename(version_hash[package_type])
      "#{Chef::Config[:file_cache_path]}/code_deploy/#{file_name}"
    end

    # If the machine uses systemd
    #
    # @return [Boolean]
    #
    def systemd?
      Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
    end

    # If the os is ubuntu less than 15
    #
    # @return [Boolean]
    #
    def ubuntu_less_than_15?
      node['platform'] == 'ubuntu' &&
        Chef::VersionConstraint.new('< 15.0').include?(node['platform_version'])
    end
  end
end
