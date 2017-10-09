require 'sinatra'
require 'json'
require 'octokit'
require 'pp'


post '/payload' do

  client = Octokit::Client.new :access_token => ENV["git_token"]
  @push = JSON.parse(request.body.read) # push data
  if @push["ref"] == "refs/heads/master"
     @push["commits"].each do |f|
     if f["modified"].include?("docs/required_vcenter_privileges.md")
      client.create_issue("pivotal-cf/docs-pcf-install", 
          "Change to vSphere Permissions", 
          "The vSphere privileges [topic](https://github.com/cloudfoundry-incubator/bosh-vsphere-cpi-release/blob/master/docs/required_vcenter_privileges.md) in the `bosh-vsphere-cpi-release` GitHub repo has been modified. Please update the relevant versions of the [Installing Pivotal Cloud Foundry on vSphere](https://docs.pivotal.io/pivotalcf/customizing/vsphere.html#permissions) topic in the PCF Core Docs.")
    end
    end
  end

end
