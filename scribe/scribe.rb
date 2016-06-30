require 'pp'
require 'optparse'
require 'Open3'

# source_required_files # make helpers available
Dir["./models/*.rb"].each {|file| require file }
Dir["./views/*.rb"].each {|file| require file }
Dir["./helpers/*.rb"].each {|file| require file }
# see source_required_files for 'require' source_required_files

# =====SOME ARGV STUFF=====

# aliases = {
# 	'u' => 'url' # to return the (pcf?) url equivalent of the repo 
# 	'c' => 'commit' # to commit all the changes, pull --rebase, push
# 	'd' => 'deliver' # to checkout and merge branch into master (or pre-release), and delete branch
#   'p' ==> 'pull' # checks out, stashes, pulls, pops branches which are behind; takes branch as argument 
#    'status' # returns status of all docs repos
# }
# =====SOME ARGV STUFF=====

class Scribe
  attr_accessor :repos, :workspace_name

	def initialize options={}
		# ARGV << 'status' if ARGV.empty?
		@books = ['docs-book-cloudfoundry', 'docs-book-pcfservices', 'docs-book-pivotalcf', 'docs-book-runpivotal']
		@repos = []
		@workspace_name = ''
		main
	end

	def main
		puts "MAIN"
		find_home # helper sets workspace and show pwd 
		add_docs_dirs_repos #helper adds repos to model
		# pp @repos
		# handle_args
		# puts test
    # batch push?
    # set commit message
    # set story number/branch
    # report owners list
	end

	def handle_args # refactor to case, with fall through being status or help
		pp ARGV
		first = ARGV.shift
		pp ARGV
		repo_statuses if first == 'status' #helper to check and show repo statuses
		repo_pull if first == 'pull' #pulls clean, can-be-ff'ed repos
		call_help if first == 'help' || first == 'h'
	end

	def repo_pull
		check_repos
		# pull_repos
	end

	def find_home 
		set_workspace_name
		show_workspace
	end


	def repo_statuses
		check_statuses 	#checks all statuses, populates repos.status
		show_statuses	#sends to the view
	end

  # has_changes_to_be_committed << repo if repo.status.include? "Changes to be committed"

end
scribe = Scribe.new 
# puts scribe.current_dir


