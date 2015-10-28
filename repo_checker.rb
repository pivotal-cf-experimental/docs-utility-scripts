class RepoChecker
  attr_accessor :repos
  def initialize
    @repos = []

    Dir.glob("/Users/mtrestman/workspace/docs-*/") { |repo|
      @repos.push(Repo.new repo)
    }

  end

  def report

    sorted_repos = sort_repos @repos

    puts "the following repos are even_steven:"
    sorted_repos[:even_steven].each { |esr| puts "\t#{esr.path}" }

    @repos.each do |repo|
      # sort_repos
      puts "||||||||||||||||||||||||||"
      puts "Hi I'm a repo! My path is #{repo.path}!\n Here's my status:\n"
      p repo.status
      puts "@@@@@@@@@@@@@@@@@@@@@@@@@@"
    end
  end

  def fetch_statuses_sequentially
    @repos.each do |repo|
  
      Dir.chdir repo.path
      
      status = `git fetch; git status`
      repo.status = status
  
    end

  end

  def sort_repos repos
    needs_pull = []
    needs_push = []
    even_steven = []
    
    repos.each do |repo|
      even_steven << repo if repo.status == "On branch master\nYour branch is up-to-date with 'origin/master'.\nnothing to commit, working directory clean\n"
    end

    {
      needs_push: needs_push,
      needs_pull: needs_pull,
      even_steven: even_steven
    }
  end


  def fetch_statuses_concurrently
    threads = []

    @repos.each do |repo|
      threads.push(Thread.new do
        Dir.chdir repo.path
        
        status = `git fetch; git status`
        
        {
          repo: repo,
          status: status
        }
      end)
    end

    threads.each do |t| 
      t.join 
    end

    threads.each do |t| 
      t.value[:repo].status = t.value[:status]
    end

  end

  def stash_rebase_stashpop
    threads = []

    @repos.each do |repo|
      threads.push(Thread.new do
        Dir.chdir repo.path
        
        status = `git fetch; git stash; git rebase; git stash pop`
        
        {
          repo: repo,
          status: status
        }
      end)
    end
    threads.each do |t| 
      t.join 
    end

    threads.each do |t| 
      t.value[:repo].status = t.value[:status]
    end

  end
end

class Repo
  attr_accessor :path, :status, :current_branch

  @status
  @path
  @current_branch

  def initialize path
    @path = path
  end


end



rc = RepoChecker.new

rc.fetch_statuses_concurrently

# rc.stash_rebase_stashpop

rc.report




# def find_workspace
#   home = `pwd`
#   dirs = home.split('/')
#   top_dir = dirs.last.gsub(/\n/, '')

#   return :top if dirs.length <= 1
#   return :workspace if top_dir == "workspace"

#   if home.include? "workspace"
#     Dir.chdir '../'
#     find_workspace
#   end
# end

# raise "cannot find workspace directory" unless find_workspace == :workspace

# results = Dir.glob "docs-*"

# home = `pwd`.gsub("\n",'')
# result_objects = results.map{ |result|
#   results = {}
#   Dir.chdir result
#   results[:pwd] = Dir.pwd.gsub("\n",'')
#   `git fetch`
#   results[:git_status] = `git status`
#   Dir.chdir home
#   results
# }

# not_ahead = "nothing to commit"
# not_behind = "Your branch is up-to-date with 'origin/master'."

# result_objects.reject!{ |result|
#   result[:git_status].include?(not_ahead) && result[:git_status].include?(not_behind)
# }

# puts "all repos are up-to-date with origin/master and have no changes to commit" if result_objects.length == 0

# result_objects.each{|result|
#   puts "***************************"
#   result.keys.each {|key| puts "#{key} : #{result[key]}\n\n" }

#   find_workspace
#   Dir.chdir result[:pwd]

#   `open -a gitx .` if ARGV.any?{|v| v=='-gitx' }

#   # if ARGV.any?{|v| v=='-add-and-commit' }
#   #   puts "adding all and committing that shiz"
#   #   `git add .; git commit -m " removes beta indication from mentions of Diego [#100610688]"; git push`
#   # end

#   # if ARGV.any?{|v| v=='-push' }
#   #   `git push`
#   # end

#   puts "$$$$$$$$$$$$$$$$$$$$$$$$"
# } 