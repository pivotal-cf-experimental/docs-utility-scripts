
class Scribe

	def initialize
		@repos = []
		@current_dir = ''
		@workspace = ''
		find_home
	end

	def find_home
	  show_current_dir
	  set_workspace
	raise "Unable to locate find workspace directory" unless show_current_dir == true
	end

	def show_current_dir
	  @current_dir = `pwd`
	  puts "Your pwd is #{@current_dir}"
	  return true if @workspace.include?('workspace')
	end

	def set_workspace
	  @workspace = @current_dir.sub(/workspace\/.+/) { "workspace" }
	  puts "Scribe will reference #{@workspace} as your workspace."		
	end
end
scribe = Scribe.new
