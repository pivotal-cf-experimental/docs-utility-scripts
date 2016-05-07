
def show_current_dir
	puts "%" * 50
	puts "@current_dir is set to #{@current_dir}"
	puts "%" * 50
	puts "Your pwd is #{@current_dir}"
end

def show_workspace
	puts "Scribe will reference #{@workspace_name} as your workspace."		
end

def show_statuses
	# puts "TEMP RETURN VALUE FOR `show_statuses`"
	# should puts string built from status report
	@repos.each{|r|print "\n#{r.docs_dir} #{whitespace r.docs_dir.size} #{r.branch} #{whitespace r.branch.size} #{r.status}" }

	# status = `git fetch; git stash; git rebase; git stash pop`

	# {
	#   repo: repo,
	#   status: status
	# }
end

def show_checking_status_courtesy
	puts ""
	puts "    Checking git status for docs repos"
end

def show_help
	puts "YOU ARE SHOWING HELP"
	puts "#" * 50
	puts "#" * 50
	puts "#" * 50
	puts "#" * 50
end


def whitespace(length)
	return " " * (35 - length)
end
