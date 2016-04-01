# helper functions

	# display pwd and dir that scribe sets as the 'workspace'
def find_home
  show_current_dir  # view 
  @workspace = set_workspace		# helper
	show_workspace workspace
  raise "Unable to locate find workspace directory" unless show_current_dir == true
end

def set_workspace
	return @current_dir.sub(/workspace\/.+/) { "workspace" }
end

# This method should probably eventually use the pubtools method that scrubs the book's configs for repos, and adds those, rather than depend on a 'clean' workspace
def add_docs_dirs_repos
    Dir.glob("#{@workspace.chomp}/docs-*/") do |repo|
    	break if repo.include? 'docs-utility'
        @repos.push Repo.new repo
	end
end

def check_statuses		
  @repos.each do |repo|
    Dir.chdir repo.path
    repo.docs_dir = repo.path.gsub(/.*\/workspace\//,'REPO: ').gsub(/\//,'')
    repo.branch = `git status | grep branch`.gsub(/On branch/, 'Branch:').gsub(/\n.*/, "")
    repo.status = `git status | grep behind`
    # repo.status = `git status | grep modified`

    # repo.status_report << `git status`.gsub(/\n.*diverged.*$/,' Diverged').gsub(/\n.*up-to-date.*$/, ' Up-to-date').gsub(/\n.*nothing to commit, working directory clean$/, " Directory Clean")
    # interact with `git status` and `pwd` 
    # where these items inform an object? a property of an object
    # repo. 
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


