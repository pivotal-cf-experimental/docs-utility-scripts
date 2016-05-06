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

				# if @filename[0] == '_'
				# 	title = '[Partial]' 
				# else
				# 	title = parsed_topic['title']
				# end

				titles_owners_links = ['z', parsed_topic['owner'], @uri]
				monster_hash[@filename] = titles_owners_links
			end
		end
		monster_hash
		end
	end
end

