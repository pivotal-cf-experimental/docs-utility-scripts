# helper functions

	# display pwd and dir that scribe sets as the 'workspace'


def set_workspace_name
	if `pwd`.include?("workspace") 
		@workspace_name = `pwd`.sub(/workspace\/.+/, "workspace").chomp 
	else
		raise "Unable to locate find workspace directory" 
	end
end

# This method should probably eventually use the pubtools method that scrubs the book's configs for repos, and adds those, rather than depend on a 'clean' workspace
def add_docs_dirs_repos
    Dir.glob("#{@workspace_name.chomp}/docs-*/") do |repo|
    	break if repo.include? 'docs-utility'
        @repos.push Repo.new repo
	end
end

def check_statuses		
	show_checking_status_courtesy
	@repos.each do |repo|
    	Dir.chdir repo.path
	    repo.docs_dir = repo.path.gsub(/.*\/workspace\//,'REPO: ').gsub(/\//,'') 
	    repo.branch = `git status | grep branch`.gsub(/On branch/, 'Branch:').gsub(/\n.*/, "")
	    repo.status = `git status` # | grep behind` 
    # repo.status = `git status | grep modified`

    # repo.status_report << `git status`.gsub(/\n.*diverged.*$/,' Diverged').gsub(/\n.*up-to-date.*$/, ' Up-to-date').gsub(/\n.*nothing to commit, working directory clean$/, " Directory Clean")
    # interact with `git status` and `pwd` 
    # where these items inform an object? a property of an object
    # repo. 
	end
end

def get_nonclean_repos
	nonclean = []
	@repos.each do |d|
		Dir.chdir(d) do
			Open3.popen3('git status') do |stdin, stdout, stderr|
			nonclean.push(d) unless stdout.read.include?('clean')
			end
		end
	end
end	

def check_repos
	puts "YOU ARE CHECKING REPOS"
	puts "$" * 50
	puts "$" * 50
	puts "$" * 50
	puts "$" * 50
	# @repos.each do |repo|
	#   Dir.chdir repo.path
	#   repo.docs_dir = repo.path.gsub(/.*\/workspace\//,'REPO: ').gsub(/\//,'')
	#   repo.branch = `git status | grep branch`.gsub(/On branch/, 'Branch:').gsub(/\n.*/, "")
	#   repo.status = `git status | grep behind`
	  # repo.status = `git status | grep modified`
	# end	
	
end

def call_help
	show_help
end

#  Using this space to temporarily rethink 'fetch_statuses'
# fetch status
#  Thread.new do
# 	 Dir.chdir repo.path 

def fetch_statuses #currently not called
	threads = []
	@repos.each do |repo|
		threads.push( new_thread )
	end
	threads.each do |t|
		t.join
	end
	threads.each do |t|
		repo = t.value[:repo]
		status = t.value[:status]
		branch = t.value[:branch]
		repo.branch = branch
		repo.status = status
	end
	report
end

def new_thread  
	Thread.new do
		Dir.chdir repo.path
		branch = `git branch -a | grep '*'`.gsub(/[*\s]/, '')

		Dir.chdir repo.path
		status = `git fetch; git status`
		{
			repo: repo,
			status: status,
			branch: branch
		}
	end
end


