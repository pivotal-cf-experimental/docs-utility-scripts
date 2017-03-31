require 'json'
require 'octokit'
require_relative 'update-stemcell-rn'

@starting_stemcell_version = ENV['STARTING_STEMCELL_VERSION']
@current_pcf_version_number = ENV['CURRENT_PCF_VERSION_NUMBER']
@path_to_stemcell_releases_json = 'docs-utility-scripts/stemcell-rn-bot/stemcell-releases.json'
@existing_stemcell_json = JSON.load(File.open(@path_to_stemcell_releases_json)).to_json
@client = Octokit::Client.new :access_token => ENV['STEMCELL_RN_BOT_GIT_TOKEN']

def get_stemcells

  # instantiate the bosh repo as a repository object
  bosh_repo = Octokit::Repository.from_url('https://github.com/cloudfoundry/bosh')

  # grab the list of releases
  bosh_releases = @client.releases(bosh_repo)

  # filter only stemcell releases
  stemcell_releases_full = bosh_releases.select do |r| 
    r[:name].start_with?("Stemcell") 
  end

  # get index of starting stemcell
  index_of_starting_stemcell = stemcell_releases_full.index do |d|
    d[:name] == "Stemcell #{@starting_stemcell_version}"
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

  return stemcell_releases.to_json

end

# if diffs between new stemcell info and existing stemcell info, then
# write the new stemcell json and run the script that updates the stemcell releases notes
new_stemcell_json = get_stemcells
if new_stemcell_json != @existing_stemcell_json 
  File.open(@path_to_stemcell_releases_json, 'w') {|f| f.write new_stemcell_json }
  @existing_stemcell_json = JSON.load(File.open(@path_to_stemcell_releases_json)).to_json
  build_new_rn
  update_rn
end

