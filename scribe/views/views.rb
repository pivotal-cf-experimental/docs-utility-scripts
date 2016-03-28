
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
	@repos.each{|r|puts r.status}
end