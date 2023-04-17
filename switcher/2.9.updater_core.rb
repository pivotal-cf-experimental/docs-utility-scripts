# Copy/paste the following line to your shell (without the #) to add `update` as an alias:
# echo 'alias update="ruby ~/workspace/docs-utility-scripts/updater.rb"' >> ~/.bash_profile; source ~/.bash_profile

# require 'colorize'
require 'yaml'

# Add new books to this array, as necessary
@books_full_name = YAML.load_file(Dir.home + '/workspace/docs-utility-scripts/updater/all_books.yml').split(" ")
@books = @books_full_name.map { |f| f.split("/").last }
@modified_repos = []
@repo_list = ["docs-layout-repo", "docs-utility-scripts"]

# Make sure you have all the books, update or clone as necessary
def get_books(books_full_name)
	@books_full_name.each do |b|
		File.directory?(Dir.home + '/workspace/' + b.split("/").last.gsub(/\w*-?\w*\//,'')) ? update_repo(b) : clone_repo(b) 
	end
end

# Create a list of the book repositories to be cloned_or_updated, send them to cloner/updater, and display the ignored modified repos.
def gather_repos(books)
	books.map do |book|
		puts book
		YAML.load(File.open(Dir.home + '/workspace/' + book + '/config.yml'))['sections'].each do |section| 
			@repo_list.push(section['repository']['name'])
		end
	end
	get_wiki
	reduced_list = reduce_list_for_current_work @repo_list
	multithread_pipe reduced_list.uniq
	display_modified_repos @modified_repos
	evangelize_updater
end

def get_wiki
	File.directory?(Dir.home + '/workspace/docs-wiki-internal') ? `cd ~/workspace/docs-wiki-internal; git checkout master; git pull` : `cd ~/workspace; git clone git@github.com:pivotal-cf-experimental/docs-wiki-internal.git`
end

# Removes repos with changes from @repo_list 
def reduce_list_for_current_work(working_repos_array)
	working_repos_array.reject! do |repo|
		repo &&	@modified_repos.push(repo) if File.directory?(Dir.home + '/workspace/' + repo.gsub(/\w*-?\w*\//,'')) && `cd ~/workspace/#{repo.gsub(/\w*-?\w*\//,'')}; git status`.include?('modified')		
	end
	working_repos_array.compact.uniq
end

def multithread_pipe(list_of_repos)
	threads = []
	list_of_repos.each{|repo| threads << Thread.new { clone_or_update repo}}
	threads.each{|t|t.join}
	puts "\n=====================================\nYour working repos have been updated! \n=====================================\n"
end

# Ternary operation that checks for directory existence, if none, clones; otherwise updates repo
def clone_or_update(repo)
		File.directory?(Dir.home + '/workspace/' + repo.gsub(/\w*-?\w*\//,'')) ? update_repo(repo) : clone_repo(repo) 
end

# Displays repos with modifications
def display_modified_repos(modified_repos)
	if modified_repos
		puts "The following repos were ignored, as they have modified contents:"
	 modified_repos.uniq.each{|repo| puts "  #{repo.gsub(/\w*-?\w*\//,'')}" }
	end
end

# `git pull` a repository 
def update_repo(repo)
	repo = repo.gsub(/\w*-?\w*\//,'')
	puts ""
	puts "Updating #{repo}"
#	`cd ~/workspace/#{repo}; git checkout 1.11; git checkout 252; git pull`
#	`cd ~/workspace/#{repo}; git checkout 1.12; git checkout 272; git pull`
#	`cd ~/workspace/#{repo}; git checkout 2.0; git checkout 283; git pull`
#	`cd ~/workspace/#{repo}; git checkout 2.1; git checkout 1.15; git pull`
#	`cd ~/workspace/#{repo}; git checkout 2.2; git checkout 2.2; git pull`
#	`cd ~/workspace/#{repo}; git checkout 2.3; git checkout 4.5; git pull`
#	`cd ~/workspace/#{repo}; git checkout 2.4; git checkout 6.7; git pull`
# `cd ~/workspace/#{repo}; git checkout 2.5; git checkout 7.9; git pull`
# `cd ~/workspace/#{repo}; git checkout 2.6; git checkout 9.3; git pull`
# `cd ~/workspace/#{repo}; git checkout 2.7; git checkout 12.0; git pull`
# `cd ~/workspace/#{repo}; git checkout 2.8; git checkout 12.21; git pull`
  `cd ~/workspace/#{repo}; git checkout 2.9; git checkout 12.42; git pull`
end

# `git clone` a repository
def clone_repo(repo)
	puts ""
	puts "Missing a local copy of #{repo}. Cloning it from GitHub."
#	`cd ~/workspace; git clone git@github.com:#{repo}.git; git checkout 1.11; git checkout 252; git pull`
#	`cd ~/workspace; git clone git@github.com:#{repo}.git; git checkout 1.12; git checkout 272; git pull`
#	`cd ~/workspace; git clone git@github.com:#{repo}.git; git checkout 2.0; git checkout 283; git pull`
#	`cd ~/workspace; git clone git@github.com:#{repo}.git; git checkout 2.1; git checkout 1.15; git pull`
#	`cd ~/workspace; git clone git@github.com:#{repo}.git; git checkout 2.2; git checkout 2.2; git pull`
#	`cd ~/workspace; git clone git@github.com:#{repo}.git; git checkout 2.3; git checkout 4.5; git pull`
#	`cd ~/workspace; git clone git@github.com:#{repo}.git; git checkout 2.4; git checkout 6.7; git pull`
# `cd ~/workspace; git clone git@github.com:#{repo}.git; git checkout 2.5; git checkout 7.9; git pull`
# `cd ~/workspace; git clone git@github.com:#{repo}.git; git checkout 2.6; git checkout 9.3; git pull`
# `cd ~/workspace; git clone git@github.com:#{repo}.git; git checkout 2.7; git checkout 12.0; git pull`
# `cd ~/workspace; git clone git@github.com:#{repo}.git; git checkout 2.8; git checkout 12.21; git pull`
  `cd ~/workspace; git clone git@github.com:#{repo}.git; git checkout 2.9; git checkout 12.42; git pull`

end

def evangelize_updater
	puts "\n==================================================================================\nUPDATE: Updater Suite®, by Macrosotf, now updates as a multi-threaded application."
	puts "        Updater Suite® now updates itself before it updates your repositories! "
end

get_books(@books_full_name)
gather_repos(@books)
