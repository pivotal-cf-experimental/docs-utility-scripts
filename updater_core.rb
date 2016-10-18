# Use this branch, the 'review' branch, to idempotently add review branches to all repos listed in the config.yml files of the four docs books: OSS, PWS, core & services. If this branch is checked out, just run `update` from CL.

# Additionally, the review sites can be used to review changes to the docs-layout-repo, so this script adds the review branch there, as well, and all commercial books publish off of the review branch of the layout repo.

require 'yaml'

# Add new books to this array, as necessary
@books = ["docs-book-cloudfoundry", "docs-book-pcfservices", "docs-book-pivotalcf", "docs-book-runpivotal"]
@modified_repos = []
@repo_list = ["docs-layout-repo", "docs-book-cloudfoundry", "docs-book-pcfservices", "docs-book-pivotalcf", "docs-book-runpivotal"]

# Create a list of the book repositories to be cloned_or_updated, send them to cloner/updater, and display the ignored modified repos.
def gather_repos(books)
	books.each do |book|
		YAML.load(File.open(Dir.home + '/workspace/' + book + '/config.yml'))['sections'].each do |section| 
			@repo_list.push(section['repository']['name'])
		end
	end
	reduced_list = reduce_list_for_current_work @repo_list
	multithread_pipe reduced_list.uniq
	display_modified_repos @modified_repos
end


# Removes repos with changes from @repo_list 
def reduce_list_for_current_work(working_repos_array)
	working_repos_array.reject! do |repo|
		repo &&	@modified_repos.push(repo) if File.directory?(Dir.home + '/workspace/' + repo.gsub(/\w*-?\w*\//,'')) && `cd ~/workspace/#{repo.gsub(/\w*-?\w*\//,'')}; git status`.include?('modified')		
	end
	working_repos_array.compact.uniq
end

def multithread_pipe(list_of_repos)
	threads = []
	list_of_repos.each{|repo| threads << Thread.new { add_review_branch? repo}}
	threads.each{|t|t.join}
	puts "\n=====================================\nYour working repos all have Re√iewable 'review' branches! \n=====================================\n"
end

# Ternary operation that checks for directory existence, if none, clones; otherwise updates repo
def add_review_branch?(repo)
		create_review_branch(repo) if File.directory?(Dir.home + '/workspace/' + repo.gsub(/\w*-?\w*\//,'')) 
end

# creates 'review' branch for every repo
def create_review_branch(repo)
	repo = repo.gsub(/\w*-?\w*\//,'')
	puts ""
	puts "Creating review branch for #{repo}"
	`git branch review; git push -u origin review`
end

gather_repos(@books)
