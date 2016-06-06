require 'yaml'
require 'find'
require 'pp'

class Book

	def initialize(book)
		@path_to_book = Dir.home + '/workspace/' + book
		@path_to_config_yml = @path_to_book + '/config.yml'
		@path_to_var_yml = @path_to_book + '/config/template_variables.yml'
	end

	#returns an array of all the repos that belong to a book
	def get_repos
		repo_list = []
		parsed_config = begin
			YAML.load(File.open(@path_to_config_yml))
		rescue ArgumentError => e
  			puts "Could not parse YAML: #{e.message}"
		end
		parsed_config['sections'].each do |section|
			repo_list.push(section['repository']['name'].gsub(/\w*-?\w*\//,''))
		end
		repo_list.sort
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
			@filename = path.split(@repo)[1] #refactor with regex to avoid extra array
			puts @filename
			if path.include?('html') && unless path.include?('/_')

				# first_line = File.open(path, &:readline) 
				# if first_line.include?('---')

				parsed_topic = begin
					five_lines = File.open(path) do |f|
						5.times.map{f.readline}.join("\n").to_s
					end
				puts five_lines
					YAML.load(five_lines)
				rescue ArgumentError => e
		  			puts "Could not parse YAML: #{e.message}"
				end
				
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
			end

				titles_owners_links = [parsed_topic['title'], parsed_topic['owner'], @uri]
				monster_hash[@filename] = titles_owners_links
			end
		end
		monster_hash
		end
	end

	def get_partials
	#future feature: list partials in a separate list
	end
end


