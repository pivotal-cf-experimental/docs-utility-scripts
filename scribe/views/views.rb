
def show_current_dir
	@current_dir = `pwd`
	puts "Your pwd is #{@current_dir}"
	return true if @workspace.include?('workspace')
end

def show_workspace(workspace)
	puts "Scribe will reference #{workspace} as your workspace."		
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


def whitespace(length)
	return " " * (35 - length)
end