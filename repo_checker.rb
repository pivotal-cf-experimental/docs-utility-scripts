def find_workspace
  home = `pwd`
  dirs = home.split('/')
  top_dir = dirs.last.gsub(/\n/, '')

  return :top if dirs.length <= 1
  return :workspace if top_dir == "workspace"

  if home.include? "workspace"
    Dir.chdir '../'
    find_workspace
  end
end

raise "cannot find workspace directory" unless find_workspace == :workspace

results = Dir.glob "docs-*"

home = `pwd`.gsub("\n",'')
result_objects = results.map{ |result|
  results = {}
  Dir.chdir result
  results[:pwd] = Dir.pwd.gsub("\n",'')
  `git fetch`
  results[:git_status] = `git status`
  Dir.chdir home
  results
}

not_ahead = "nothing to commit"
not_behind = "Your branch is up-to-date with 'origin/master'."

result_objects.reject!{ |result|
  result[:git_status].include?(not_ahead) && result[:git_status].include?(not_behind)
}

puts "all repos are up-to-date with origin/master and have no changes to commit" if result_objects.length == 0

result_objects.each{|result|
  puts "***************************"
  result.keys.each {|key| puts "#{key} : #{result[key]}\n\n" }

  find_workspace
  Dir.chdir result[:pwd]
  `open -a gitx .` if ARGV.any?{|v| v=='-gitx' }
  if ARGV.any?{|v| v=='-push' }
    puts "??????????????\n\nreally push the following?\n\n#{result[:git_status]}\n\n?????????????????"

  end

  puts "$$$$$$$$$$$$$$$$$$$$$$$$"
}

