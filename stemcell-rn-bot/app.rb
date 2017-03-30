require 'yaml'
require 'octokit'

# this should be set as an ENV VAR
starting_stemcell_version = '3363'

# use token to authenticate
client = Octokit::Client.new :access_token => ENV['stemcell_rn_bot_git_token']

# instantiate the bosh repo as a repository object
bosh_repo = Octokit::Repository.from_url('https://github.com/cloudfoundry/bosh')

# grab the list of releases
bosh_releases = client.releases(bosh_repo)

# filter only stemcell releases
stemcell_releases_full = bosh_releases.select do |r| 
  r[:name].start_with?("Stemcell") 
end

# get index of starting stemcell
index_of_starting_stemcell = stemcell_releases_full.index do |d|
  d[:name] == "Stemcell #{starting_stemcell_version}"
end

stemcell_releases_full = stemcell_releases_full[0..index_of_starting_stemcell]

# filter only name, date, and body info into new hash
stemcell_releases = []
stemcell_releases_full.each do |d|
  new_hash = d.select do |k,v| 
   [:name, :published_at, :body].include?(k)
  end
  stemcell_releases.push(new_hash)
end

# wipe existing stemcell-releases yaml
File.open('stemcell-releases.yml', 'w') {|f| f.truncate(0) }

File.open('stemcell-releases.yml', 'w') {|f| f.write stemcell_releases.to_yaml }
