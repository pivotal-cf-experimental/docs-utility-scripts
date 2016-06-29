# Copy/paste the following line to your shell (without the #) to add `update` as an alias:
# echo 'alias update="ruby ~/workspace/docs-utility-scripts/updater.rb"' >> ~/.bash_profile; source ~/.bash_profile

require 'pp'
require 'yaml'
require 'open3'

# Add new books to this array, as necessary
@books = ['docs-book-cloudfoundry', 'docs-book-pcfservices', 'docs-book-pivotalcf', 'docs-book-runpivotal']
@modified_repos = []
@repo_list = ["docs-layout-repo", "docs-utility-scripts"]
@output = {}

# Create a list of the book repositories to be cloned_or_updated, send them to cloner/updater, and display the ignored modified repos.
def gather_repos(books)
	books.map do |book|
		YAML.load(File.open(Dir.home + '/workspace/' + book + '/config.yml'))['sections'].each do |section| 
			@repo_list.push(section['repository']['name'])
		end
	end
	reduced_list = reduce_list_for_current_work @repo_list
	multithread_pipe reduced_list.uniq
	# clone_or_update reduced_list.uniq
	display_modified_repos @modified_repos
	pp @output
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
	puts "========\nYour working repos have been updated \n"
end

# def multithread_pipe(list_of_repos)
# 	threads = []
# 	list_of_repos.each do |repo|
# 		threads << Thread.new do
			# Open3.popen3(clone_or_update repo) do |stdin, stdout, stderr|
			  # @output[repo] = "STDOUT: #{stdout.read}"
			  # @output[repo] = stdin.read
			  # @output[repo] = "STDERR: #{stderr.read}"
			  # clone_or_update repo
			# end
		 
		# end
	# end
	# pp @output
	# threads.each{|t|t.join}
# end

# Ternary operation that checks for directory existence, if none, clones; otherwise updates repo
def clone_or_update(repo)
		File.directory?(Dir.home + '/workspace/' + repo.gsub(/\w*-?\w*\//,'')) ? update_repo(repo) : clone_repo(repo) 
end

# Displays repos with modifications
def display_modified_repos(modified_repos)
	if modified_repos
		puts ""
		puts "The following repos were ignored, as they have modified contents:"
	 modified_repos.uniq.each{|repo| puts "  #{repo.gsub(/\w*-?\w*\//,'')}" }
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
	puts ""
	puts "It seems you do not have a local copy of #{repo}."
	puts "  ...Cloning it from Github, now."
	`cd ~/workspace; git clone git@github.com:#{repo}.git`
end

gather_repos(@books)
