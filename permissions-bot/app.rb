require 'octokit'
require 'net/http'

client = Octokit::Client.new :access_token => ENV["git_token"]


old_file = File.read('docs-utility-scripts-master/permissions-bot/required_vcenter_privileges.md').gsub(/\s+/, "")

new_file_url = URI.parse('https://raw.githubusercontent.com/cloudfoundry-incubator/bosh-vsphere-cpi-release/master/docs/required_vcenter_privileges.md')

new_file = Net::HTTP.get(new_file_url).gsub(/\s+/, "")

if old_file != new_file
  client.create_issue("pivotal-cf/docs-pcf-install", 
          "Change to vSphere Permissions", 
          "The vSphere privileges [topic](https://github.com/cloudfoundry-incubator/bosh-vsphere-cpi-release/blob/master/docs/required_vcenter_privileges.md) in the `bosh-vsphere-cpi-release` GitHub repo has been modified. Please update the relevant versions of the [vSphere Service Account Requirements](https://docs.pivotal.io/pivotalcf/customizing/vsphere-service-account.html) topic in the PCF Core Docs.")
  File.open('docs-utility-scripts-master/permissions-bot/required_vcenter_privileges.md', 'w') {
    |file| file.write(new_file)
  }
end