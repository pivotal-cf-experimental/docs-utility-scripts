curr_dirr = `pwd`

unless /docs-book-/.match curr_dirr
	puts 'error: you must be in the top level of a docs-book-* directory with a config.yml to use this script!'
	exit
end

puts "what repo(s) do you want to leave uncommented? separate by commas if more than 1:"
repo_keywords = gets.chomp.gsub(' ', '').split(',')

if repo_keywords == [] or repo_keywords[0].gsub(' ','') == ''
	repo_keywords << [' ']
end

puts "here are your repo keywords:"
repo_keywords.each { |k| p "keyword: #{k}" }

config_yml = './config.yml'
config_yml = File.read(config_yml)
config_yml.gsub!(/(- repo|public_host)/, "$$$\n\\1")

config_yml.gsub!('###', '')
repo_regex = /- repository.*?\$\$\$/m


repos = config_yml.scan repo_regex

# repos.each_with_index do |repo,i|
# 	puts "***\nrepo number #{i}: \n#{repo}\n%%%\n\n"
# end

repos.each_with_index do |repo,i|

	orig_repo = repo.clone
	repo.gsub!('###', '')
	is_a_match = true

	unless repo_keywords.any?{ |kw| !!repo.match(/#{kw}/m) }
		repo.gsub!(/(- repo)/, '###- repo')
		repo.gsub!(/\n/, "\n###")
		is_a_match = false
	end

	config_yml = config_yml.sub(orig_repo, repo)

end
config_yml.gsub!(/\n\$\$\$/,'')
File.open('./config.yml', "w") { |file| file << config_yml }
