
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
	@repos.each{|r|puts "\n#{r.docs_dir} \n#{r.status}" }

	# status = `git fetch; git stash; git rebase; git stash pop`

	# {
	#   repo: repo,
	#   status: status
	# }


end