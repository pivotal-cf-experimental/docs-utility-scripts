require 'yaml'
require 'find'
require 'pp'

class Book

	def initialize(path_to_book)
		@path_to_config_yml = path_to_book + '/config.yml'
		@path_to_var_yml = path_to_book + '/config/template_variables.yml'
	end

	#returns an array of all the repos that belong to a book
	def get_repos
		repo_list = []
		
		parsed_config = begin
			YAML.load(File.open(@path_to_config_yml))
		rescue ArgumentError => e
  			puts "Could not parse YAML: #{e.message}"
		end
		
		parsed_config['sections'].each do |n|
			repo = n['repository']['name']
			repo = repo.split('/')[1] if repo.include?('/')
			repo_list.push(repo)
		end

		repo_list
	end

	#returns a hash of all the template vars that belong to a book
	def get_vars
		vars_hash = {}

		parsed_config = begin
			YAML.load(File.open(@path_to_var_yml))
		rescue ArgumentError => e
  			puts "Could not parse YAML: #{e.message}"
		end

		parsed_config['template_variables'].each do |n|
			vars_hash[n[0]] = n[1]
		end

		vars_hash
	end

end

class Repo

	def initialize(repo, book)
		@repo = repo
		@path_to_repo = Dir.home + '/workspace/' + repo
		@book = book
		@path_to_config_yml = Dir.home + '/workspace/' + book + '/config.yml'
		@books_and_uris = {
			'docs-book-pivotalcf' => 'http://docs.pivotal.io/',
			'docs-book-cloudfoundry' => 'http://docs.cloudfoundry.org/',
			'docs-book-runpivotal' => 'http://docs.run.pivotal.io/'
			}
	end

	#return a hash {filename => title, owner, link}
	def get_info
		monster_hash = {}
		if Dir.exist?(@path_to_repo)
			Find.find(@path_to_repo) do |path|
			if path.include?('html')
				parsed_topic = begin
					YAML.load(File.open(path))
				rescue ArgumentError => e
		  			puts "Could not parse YAML: #{e.message}"
				end
				@filename = path.split(@repo)[1]
				
				parsed_book = begin
  				YAML.load(File.open(@path_to_config_yml))
				rescue ArgumentError => e
				  puts "Could not parse YAML: #{e.message}"
				end

				parsed_book["sections"].each do |n|
					if n['repository']['name'].include?(@repo)
						domain = @books_and_uris[@book]
						edited_filename = @filename.split('.md.erb')[0]
						@uri = domain + n['directory'] + edited_filename
					end
				end

				titles_owners_links = [parsed_topic['title'], parsed_topic['owner'], @uri]
				monster_hash[@filename] = titles_owners_links
			end
		end
		monster_hash
		end
	end
end



# b = Book.new(Dir.home + '/workspace/docs-book-pivotalcf')
# pp b.get_vars

r = Repo.new('docs-buildpacks', 'docs-book-pivotalcf')
pp r.get_info


# parse_yaml(Dir.home + '/workspace/docs-book-pivotalcf/config.yml', 'http://docs.pivotal.io/')
# parse_yaml(Dir.home + '/workspace/docs-book-cloudfoundry/config.yml', 'http://docs.cloudfoundry.org/')
# parse_yaml(Dir.home + '/workspace/docs-book-runpivotal/config.yml', 'http://docs.run.pivotal.io/')
























# b = Book.new(Dir.home + '/workspace/docs-book-pivotalcf')
# repos = b.get_repos
# repos.each do |n|
# 	repo_path = Dir.home + '/workspace/' + n
# 	r = Repo.new(repo_path)
# 	puts r.get_topic_filenames
# 	puts r.get_topic_titles
# end


# Find.find(Dir.home + '/workspace/docs-identity') do |path|
# 	puts path if path.include?('html')
# end


#Get all file names, topics, and links in a repo


# r = Book.new(Dir.home + '/workspace/docs-book-pivotalcf')
# puts r.get_vars


# def parse_yaml(path, domain)
# book = begin


















# 	uri = domain + n['directory']
# 	if @bigboy.has_key?(repo.to_sym)
# 		if @bigboy[repo.to_sym].is_a?(Array)
# 			@bigboy[repo.to_sym].push(uri)
# 		else
# 			@bigboy[repo.to_sym] = @bigboy[repo.to_sym].split.push(uri)
# 		end
# 	else
# 		@bigboy[repo.to_sym] = uri
# 	end	
# end
# end

# puts Dir.home

# parse_yaml(Dir.home + '/workspace/docs-book-pivotalcf/config.yml', 'http://docs.pivotal.io/')
# parse_yaml(Dir.home + '/workspace/docs-book-cloudfoundry/config.yml', 'http://docs.cloudfoundry.org/')
# parse_yaml(Dir.home + '/workspace/docs-book-runpivotal/config.yml', 'http://docs.run.pivotal.io/')


# #convert a uri to a repo
# def uri_to_repo(uri)
# 	parsed = URI.parse(uri)
# 	new_uri = parsed.to_s
# 	new_uri.gsub!("https", "http") if parsed.scheme == "https"
# 	new_uri.chop! if new_uri[-1] == "/"
# 	if @bigboy.value?(new_uri)
# 		puts "\nThe repo for " + "#{ARGV[0]} ".green + "is " + "#{@bigboy.key(new_uri)}".red
# 	elsif @bigboy.values.flatten.include?(new_uri)
# 		arrays = @bigboy.values.select { |n| n.is_a?(Array) }
# 		matches = arrays.select { |n| n.include?(new_uri) }
# 		puts  "\nThe repo for " + "#{ARGV[0]} ".green + "is " + "#{@bigboy.key(matches.flatten)}".red
# 	else 
# 		puts "\nSorry, I can't find that URI.".magenta
# 	end
# end

# #convert a repo to a uri
# def repo_to_uri(repo)
# 	if @bigboy.key?(repo.to_sym)
# 		if @bigboy[repo.to_sym].is_a?(Array)
# 			puts "\nThe URIs for " + "#{ARGV[0]}".red + " are: "
# 			@bigboy[repo.to_sym].each { |n| puts n.green }
# 		else
# 			puts "\nThe URI for " + "#{ARGV[0]} ".red + "is " + " #{@bigboy[repo.to_sym]}".green
# 		end
# 	else
# 		puts "\nSorry, I can't find that repo.".magenta
# 	end
# end

# #arguments
# if ARGV[0] =~ URI.regexp
# 	uri_to_repo(ARGV[0])
# elsif ARGV[0] =~ /[a-z]{3,4}-[a-z]+/
# 	repo_to_uri(ARGV[0])
# elsif ARGV[0] == "--all"
# 	@bigboy.each { |k, v| puts k.to_s.red + "\n" + v.to_s.green + "\n\n" }
# elsif ARGV.empty?
# 	puts "\nNAME:\n".bold + " r2u - A tool to convert URIs to Docs repo names, and vice versa.\n"
# 	puts "\nUSAGE:\n".bold + "ruby r2u.rb" + " [URI or repo name]" 
# 	puts "Converts a URI to a repo name, and vice versa".red
# 	puts "ruby r2u.rb" + " --all"  
# 	puts "Prints the whole hash".red
# 	puts "\nEXAMPLE\n".bold + "$ ruby r2u.rb docs-services"
# 	puts "The URIs for" + " docs-services".red + " are: "
# 	puts "http://docs.pivotal.io/pivotalcf/services/".green
# 	puts "http://docs.run.pivotal.io/services/".green
# 	puts "http://docs.cloudfoundry.org/services/".green
# else
# 	puts "\nSomething went wrong. Check the spelling of your URI or repo and try again.".magenta
# end
