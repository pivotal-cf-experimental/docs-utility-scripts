require 'optparse'
# see source_required_files for 'require' source_required_files

class Scribe
  attr_accessor :repos, :workspace

	def initialize
		source_required_files
		@repos = []
		@current_dir = ''
		@workspace = ''
		find_home
		add_docs_dirs_repos
	end

	def source_required_files
		Dir["./models/*.rb"].each {|file| require file }
		Dir["./helpers/*.rb"].each {|file| require file }
	end

	# check status
	 #  def fetch_statuses_sequentially
  #   @repos.each do |repo|

  #     Dir.chdir repo.path

  #     status = `git fetch; git status`
  #     repo.status = status

  #   end
  #   get_user_to_choose
  # end


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

	def add_docs_dirs_repos
    Dir.glob("#{@workspace.chomp}/docs-*/") do |repo|
        @repos.push(Repo.new repo)
        @repos.reject!{|r| r.path.include? 'docs-utility'}
      end
    @repos.each do |i|
	    puts i.path 
	end
	puts "<" * 25
	puts @repos[0].path

	puts "<" * 25
	end
end
scribe = Scribe.new
