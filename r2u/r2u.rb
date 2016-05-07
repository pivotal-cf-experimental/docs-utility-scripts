require 'uri'
require 'colorize'
require 'yaml'

@bigboy = Hash.new

#build the hash
def parse_yaml(path, domain)
book = begin
  YAML.load(File.open(path))
rescue ArgumentError => e
  puts "Could not parse YAML: #{e.message}"
end
book["sections"].each do |n|
	repo = n['repository']['name']
	repo = repo.split('/')[1] if repo.include?('/')
	uri = domain + n['directory']
	if @bigboy.has_key?(repo.to_sym)
		if @bigboy[repo.to_sym].is_a?(Array)
			@bigboy[repo.to_sym].push(uri)
		else
			@bigboy[repo.to_sym] = @bigboy[repo.to_sym].split.push(uri)
		end
	else
		@bigboy[repo.to_sym] = uri
	end	
end
end

puts Dir.home

parse_yaml(Dir.home + '/workspace/docs-book-pivotalcf/config.yml', 'http://docs.pivotal.io/')
parse_yaml(Dir.home + '/workspace/docs-book-cloudfoundry/config.yml', 'http://docs.cloudfoundry.org/')
parse_yaml(Dir.home + '/workspace/docs-book-runpivotal/config.yml', 'http://docs.run.pivotal.io/')


#convert a uri to a repo
def uri_to_repo(uri)
	parsed = URI.parse(uri)
	new_uri = parsed.to_s
	new_uri.gsub!("https", "http") if parsed.scheme == "https"
	new_uri.chop! if new_uri[-1] == "/"
	if @bigboy.value?(new_uri)
		puts "\nThe repo for " + "#{ARGV[0]} ".green + "is " + "#{@bigboy.key(new_uri)}".red
	elsif @bigboy.values.flatten.include?(new_uri)
		arrays = @bigboy.values.select { |n| n.is_a?(Array) }
		matches = arrays.select { |n| n.include?(new_uri) }
		puts  "\nThe repo for " + "#{ARGV[0]} ".green + "is " + "#{@bigboy.key(matches.flatten)}".red
	else 
		puts "\nSorry, I can't find that URI.".magenta
	end
end

#convert a repo to a uri
def repo_to_uri(repo)
	if @bigboy.key?(repo.to_sym)
		if @bigboy[repo.to_sym].is_a?(Array)
			puts "\nThe URIs for " + "#{ARGV[0]}".red + " are: "
			@bigboy[repo.to_sym].each { |n| puts n.green }
		else
			puts "\nThe URI for " + "#{ARGV[0]} ".red + "is " + " #{@bigboy[repo.to_sym]}".green
		end
	else
		puts "\nSorry, I can't find that repo.".magenta
	end
end

#arguments
if ARGV[0] =~ URI.regexp
	uri_to_repo(ARGV[0])
elsif ARGV[0] =~ /[a-z]{3,4}-[a-z]+/
	repo_to_uri(ARGV[0])
elsif ARGV[0] == "--all"
	@bigboy.each { |k, v| puts k.to_s.red + "\n" + v.to_s.green + "\n\n" }
elsif ARGV.empty?
	puts "\nNAME:\n".bold + " r2u - A tool to convert URIs to Docs repo names, and vice versa.\n"
	puts "\nUSAGE:\n".bold + "ruby r2u.rb" + " [URI or repo name]" 
	puts "Converts a URI to a repo name, and vice versa".red
	puts "ruby r2u.rb" + " --all"  
	puts "Prints the whole hash".red
	puts "\nEXAMPLE\n".bold + "$ ruby r2u.rb docs-services"
	puts "The URIs for" + " docs-services".red + " are: "
	puts "http://docs.pivotal.io/pivotalcf/services/".green
	puts "http://docs.run.pivotal.io/services/".green
	puts "http://docs.cloudfoundry.org/services/".green
else
	puts "\nSomething went wrong. Check the spelling of your URI or repo and try again.".magenta
end
