require 'optparse'
# source_required_files # make helpers available
Dir["./models/*.rb"].each {|file| require file }
Dir["./views/*.rb"].each {|file| require file }
Dir["./helpers/*.rb"].each {|file| require file }
# see source_required_files for 'require' source_required_files

# =====SOME ARGV STUFF=====
# ARGV << 'status' if ARGV.empty

# aliases = {
# 	'u' => 'url' # to return the (pcf?) url equivalent of the repo 
# 	'c' => 'commit' # to commit all the changes, pull --rebase, push
# 	'd' => 'deliver' # to checkout and merge branch into master (or pre-release), and delete branch
#   'p' ==> 'pull' # checks out, stashes, pulls, pops branches which are behind; takes branch as argument 
#    'status' # returns status of all docs repos
# }
# =====SOME ARGV STUFF=====

class Scribe
  attr_accessor :repos, :workspace

	def initialize options={}
		@repos = []
		@current_dir = ''
		@workspace = ''
		main
	end

	def main
		find_home # helper show pwd and sets workspace
		add_docs_dirs_repos #helper adds repos to model
		args
		# repo_statuses 
		# puts test
    # batch push?
    # set commit message
    # set story number/branch
    # report owners list
	end

	def args 
		first = ARGV.shift
		repo_statuses if first == 'status' #helper to check and show repo statuses
		repo_pull if first == 'pull' #pulls clean, can-be-ff'ed repos
	end

	def repo_pull
		check_repos
		# pull_repos
	end

	def repo_statuses
		check_statuses 	#checks all statuses, populates repos.status
		show_statuses	#sends to the view
	end

  # has_changes_to_be_committed << repo if repo.status.include? "Changes to be committed"

end
scribe = Scribe.new 




