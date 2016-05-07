require 'Open3'
require 'colorize'

@dirs = []
@stats = {}

#get a list of directories in our workspace
def get_dirs
    Dir.chdir(Dir.home + '/workspace')
	Dir.glob('*/').each do |d|
		@dirs.push(d)
	end
end

#cd into each directory and do a `git branch`
def get_branches

    @dirs.each do |d|
            Dir.chdir(d) do
        	Open3.popen3('git branch') do |stdin, stdout, stderr|
                @stats[d] = stdout.read
               end
            end
        end
  end

get_dirs
get_branches

#find our current branch
@stats.each do |k,v|
    @stats[k] = v[/(?<=\*.).*/]
    @stats.delete(k) unless @stats[k]
end

if ARGV[0] == "-a"
    puts "\nShowing all current git branches...".bold
    puts "\nDIRECTORY".green.bold + " | ".bold + "BRANCH".red.bold
    puts "------------------".bold
    @stats.each do |k,v|
        puts k.chop.green.bold + " | ".bold + v.red.bold
    end

elsif ARGV[0] == "-m"
    puts "\nShowing all current master branches...".bold
    puts "\nDIRECTORY".green.bold + " | ".bold + "BRANCH".red.bold
    puts "------------------".bold
    @stats.each do |k,v|
        puts k.chop.green.bold + " | ".bold + v.red.bold if v == "master"
    end

elsif ARGV[0] == "-n"
    puts "\nShowing all current non-master branches...".bold
    puts "\nDIRECTORY".green.bold + " | ".bold + "BRANCH".red.bold
    puts "------------------".bold
    @stats.each do |k,v|
        puts k.chop.green.bold + " | ".bold + v.red.bold unless v == "master"
    end

elsif ARGV[0] == "-p"
    puts "\nShowing all current pre-release branches...".bold
    puts "\nDIRECTORY".green.bold + " | ".bold + "BRANCH".red.bold
    puts "------------------".bold
    @stats.each do |k,v|
        puts k.chop.green.bold + " | ".bold + v.red.bold if v == "pre-release"
    end

elsif ARGV[0] == "-b"
    branch = ARGV[1]
    puts "\nShowing all current \"#{branch}\" branches...".bold
    puts "\nDIRECTORY".green.bold + " | ".bold + "BRANCH".red.bold
    puts "------------------".bold
    @stats.each do |k,v|
        puts k.chop.green.bold + " | ".bold + v.red.bold if v == branch
    end

elsif ARGV.empty?
    puts "\nNAME:\n".bold + "brunch".red + " tells you what git branches you're on."
    puts "\nUSAGE:\n".bold + "Run " + "brunch".red + " from your ~/workspace directory."
    puts "\nFLAGS:\n".bold + "brunch -a" + "\nLists your current git branch in all directories in your workspace.".green
    puts "\nbrunch -m" + "\nLists only those directories where your current git branch is".green + " master.".green.bold
    puts "\nbrunch -n" + "\nLists only those directories where your current git branch is".green + " not master.".green.bold
    puts "\nbrunch -p" + "\nLists only those directories where your current git branch is".green + " pre-release.".green.bold
    puts "\nbrunch -b [YOUR-BRANCH]" + "\nLists only those directories where your current git branch is".green + " YOUR-BRANCH.".green.bold
end


