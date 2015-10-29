class RepoChecker

  attr_accessor :repos

  def initialize

    @repos = []
    @repos_needing_a_pull = []
    @repos_needing_a_push = []

    Dir.glob("/Users/mtrestman/workspace/docs-*/") { |repo|
      @repos.push(Repo.new repo)
      @repos.reject!{|r| r.path.include? 'docs-utility'}
    }

  end

  def report

    puts "All repos"
    @repos.each { |esr| puts "\t#{esr.path}" }

    sorted_repos = sort_repos @repos

    puts "the following repos are even steven:"
    sorted_repos[:even_steven].each { |esr| puts "\t#{esr.path}" }

    puts "the following repos need a pull:"
    sorted_repos[:needs_pull].each { |npr| puts "\t#{npr.path}"}

    puts "the following repos need a push: "
    @repos_needing_a_push.each { |npr| puts "\t#{npr.path}"}

    puts "Other repos:"
    (@repos - sorted_repos[:needs_pull] - sorted_repos[:even_steven] ) .each do |repo|
      # sort_repos
      puts "-------------------------"
      puts "Hi I'm a repo! My path is #{repo.path}!\n Here's my status:\n"
      p repo.status
      puts "-------------------------"
    end
  end

  def get_urls
    urls = @repos.map do |repo|
      Dir.chdir repo.path
      url = `git remote show origin | grep "Fetch" `
    end

    p urls
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
      needs_pull << repo if repo.status.include? "On branch master\nYour branch is behind 'origin/master'"
      needs_push << repo if (
        repo.status.include? "Changes not staged for commit:" and repo.status.include? "modified:"
        )
    end

    @repos_needing_a_push = needs_push
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

  def batch_push_with_message message
    threads = []
    @repos_needing_a_push.each do |repo|

      threads.push(Thread.new do
        Dir.chdir repo.path
        
        status = `git add .; git commit -m '#{message}'; git push`

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

def interact rc

  puts "what would you like to do next?"

  puts "1: exit RepoChecker"
  puts "2: view statuses of repos that need a pull"
  puts "3: stash local changes, rebase, then stash pop all repos"
  puts "4: get urls (really slow, under construction)"
  puts "5: do the following to all repos_needing_a_push: git add. ; git commit -m 'message'; git rebase; git push"
  puts "6: fetch fresh statuses"
  print "your response:"

  response = gets.chomp
  
  if response == "3"
    rc.stash_rebase_stashpop 
    rc.report
    interact rc
  elsif response == "4"
    rc.get_urls
  elsif response == "5"
    puts
    print "enter commit message:   "
    message = gets.chomp
    rc.batch_push_with_message message
  elsif response == "6"
    rc.fetch_statuses_concurrently
    rc.report
    interact rc
  end

end

rc = RepoChecker.new

rc.fetch_statuses_concurrently

# rc.stash_rebase_stashpop

rc.report

interact rc



