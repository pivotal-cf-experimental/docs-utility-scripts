class RepoChecker

  def initialize

    @repos = []
    @repos_needing_a_pull = []
    @repos_needing_a_push = []
    @repos_not_on_master = []

    Dir.glob("/Users/mtrestman/workspace/docs-*/") { |repo|
      @repos.push(Repo.new repo)
      @repos.reject!{|r| r.path.include? 'docs-utility'}
    }
    fetch_statuses
    get_user_to_choose
  end

  def show_repos_needing_a_pull
    unless @repos_needing_a_pull.length
      puts "no repos need a pull"
      return
    end
    @repos_needing_a_pull.each do |repo|
      puts "-----------------------"
      puts repo.status
      puts "-----------------------"

    end
    get_user_to_choose
  end



  
  def report

    puts "All repos being tracked:"
    @repos.each { |esr| puts "\t#{esr.path}" }

    puts "-------------------------"
    
    sort_repos @repos

    puts "the following repos are even with origin/master:"
    @even.each { |esr| puts "\t#{esr.path}" }
    puts "-------------------------"
    puts "the following repos need a pull:"
    @repos_needing_a_pull.each { |npr| puts "\t#{npr.path}"}
    puts "-------------------------"

    puts "the following repos need a push: "
    @repos_needing_a_push.each { |npr| puts "\t#{npr.path}"}
    puts "-------------------------"

    puts "the following repos are not on master: "
    @repos_not_on_master.each { |nmr| puts "\t#{nmr.path} is on branch #{nmr.branch}"}
    puts "-------------------------"

    puts "Other repos:"

    ( @repos - @repos_needing_a_pull - @repos_needing_a_push - @even) .each do |repo|
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts "Repo path:\n\t#{repo.path}!\n branch:\b\t#{repo.branch}\nstatus:\n\t#{repo.status}"
      p repo.status
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
    end
    get_user_to_choose
  end


  def fetch_statuses
    threads = []

    @repos.each do |repo|
      threads.push(Thread.new do
        Dir.chdir repo.path
        branch = `git branch -a | grep '*'`.gsub(/[*\s]/, '')

        Dir.chdir repo.path
        status = `git fetch; git status`
        

        {
          repo: repo,
          status: status,
          branch: branch
        }
      end)
    end

    threads.each do |t|
      t.join
    end

    threads.each do |t|
      repo = t.value[:repo]
      status = t.value[:status]
      branch = t.value[:branch]
      repo.branch = branch
      repo.status = status
    end
    report
  end

  def stash_rebase_stashpop
    threads = []

    @repos_needing_a_pull.each do |repo|
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
      repo = t.value[:repo]
      if repo.status != t.value[:status]
        p t.value[:status]
        repo.status = t.value[:status]
      end
    end
    report
  end

  def batch_commit_and_push_with_message
    puts "this method is under construction"
    return
    # puts "*****************\nthis method is pretty dangerous; make sure you really want to commit and push everything. You should probably rebase first too."



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
    get_user_to_choose
  end


  private

  def get_urls
    urls = @repos.map do |repo|
      Dir.chdir repo.path
      url = `git remote show origin | grep "Fetch" `
    end

    p urls
    get_user_to_choose
  end

  def fetch_statuses_sequentially
    @repos.each do |repo|

      Dir.chdir repo.path

      status = `git fetch; git status`
      repo.status = status

    end
    get_user_to_choose
  end

  def sort_repos repos

    needs_pull = []
    needs_push = []
    even = []
    not_on_master = []
    
    repos.each do |repo|
      even << repo if repo.status == "On branch master\nYour branch is up-to-date with 'origin/master'.\nnothing to commit, working directory clean\n"
      needs_pull << repo if repo.status.include? "On branch master\nYour branch is behind 'origin/master'"
      needs_push << repo if ( repo.status.include? "Changes not staged for commit:" and repo.status.include? "modified:")
      not_on_master << repo if repo.branch != "master"
    end

    @repos_needing_a_push = needs_push
    @repos_needing_a_pull = needs_pull
    @even = even
    @repos_not_on_master = not_on_master
    
    return nil

  end

  attr_accessor :repos

  def get_user_to_choose

    choices = self.methods - self.class.superclass.new.methods

    puts "please enter the number of your choice."

    choices.push('quit') unless choices.any? { |choice| choice == 'quit' }
  
    choices.each_with_index do |choice, i|
      puts "- #{i}: #{choice.to_s.gsub('_', ' ')}"
    end

    print "Choice:  "
    choice = user_choice = gets.downcase.gsub(/\s/, '_')

    choice = choice.to_i

    if self.respond_to? choices[choice]
      self.send choices[choice]
    elsif choice > choices.length - 1
      get_user_to_choose
    elsif choice.to_i == choices.length - 1
      puts "bye!"
      return nil
    end
    return nil
  end

end

class Repo
  attr_accessor :path, :status, :branch

  @status
  @path
  @branch

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

  if response == "2"
    rc.show_repos_needing_a_pull
    interact rc

  elsif response == "3"
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
    rc.fetch_statuses
    rc.report
    interact rc
  end

end



rc = RepoChecker.new

rc.fetch_statuses

# rc.stash_rebase_stashpop

rc.report

# interact rc



