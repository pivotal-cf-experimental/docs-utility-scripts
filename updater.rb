# Copy/paste the following line to your shell (without the #) to add `update` as an alias:
# echo 'alias update="ruby ~/workspace/docs-utility-scripts/updater.rb"' >> ~/.bash_profile; source ~/.bash_profile

require 'yaml'

# Add new books to this array, as necessary
@books = ['docs-book-cloudfoundry', 'docs-book-pcfservices', 'docs-book-pivotalcf', 'docs-book-runpivotal']

# Create a list of the book repositories to be cloned_or_updated, and send them to cloner/updater.
def gather_repos(books)
	repo_list = []
	books.map do |book|
		YAML.load(File.open(Dir.home + '/workspace/' + book + '/config.yml'))['sections'].each do |section| 
			repo_list.push(section['repository']['name'])
		end
	end
	clone_or_update repo_list.uniq
end

# Ternary operation that checks for directory existence, if none, clones; otherwise updates repo
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

gather_repos(@books)
