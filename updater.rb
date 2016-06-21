# Copy/paste the following line to your shell (without the #) to add `update` as an alias:
# echo 'alias update="ruby ~/workspace/docs-utility-scripts/updater.rb"' >> ~/.bash_profile; source ~/.bash_profile

require 'yaml'

# Create a list of the book repositories to be cloned_or_updated, and send them to cloner/updater.
def gather_repos (book)
	repo_list = []
	book_repos = begin
		YAML.load(File.open(Dir.home + '/workspace/' + book + '/config.yml'))
	rescue ArgumentError => e
			puts "Could not parse YAML: #{e.message}"
	end
	book_repos['sections'].each{|section| repo_list.push(section['repository']['name'])}
	clone_or_update repo_list
end

# Ternary operation that checks for directory existence, if none, clones, otherwise updates repo
def clone_or_update(repo_list)
	repo_list.each do |repo|
		File.directory?(Dir.home + '/workspace/' + repo.gsub(/\w*-?\w*\//,'')) ? update_repo(repo) : clone_repo(repo) 
	end	
end

# `git pull` a repository 
def update_repo(repo)
	repo = repo.gsub(/\w*-?\w*\//,'')
	puts ""
	puts "Updating #{repo}"
	`cd ~/workspace/#{repo}; git checkout master; git pull`
end

# `git clone` a repository
def clone_repo(repo)
	repo = repo.gsub(/\w*-?\w*\//,'')
	puts ""
	puts "It seems you do not have a local copy of #{repo}."
	puts "  ...Cloning it from Github, now."
	`cd ~/workspace; git clone git@github.com:#{repo}.git`
end

gather_repos 'docs-book-cloudfoundry'
gather_repos 'docs-book-pcfservices'
gather_repos 'docs-book-pivotalcf'
gather_repos 'docs-book-runpivotal'
