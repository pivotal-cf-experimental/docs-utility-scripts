# Use this branch, the 'review' branch, to idempotently add review branches to all repos listed in the config.yml files of the four docs books: OSS, PWS, core & services. If this branch is checked out, just run `update` from CL.

# Additionally, the review sites can be used to review changes to the docs-layout-repo, so this script adds the review branch there, as well, and all commercial books publish off of the review branch of the layout repo.

require 'yaml'

# Change this number to the branch name you wish to create.
NEW_VERSION = '1.8'


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
	@repo_list.delete('cloudfoundry/uaa')
	review_check @repo_list.uniq
end

def review_check(repo_list)
	version = NEW_VERSION
	repo_list.each do |repo|
		check_for_branch(repo, version) if File.directory?(Dir.home + '/workspace/' + repo.gsub(/\w*-?\w*\//,''))
		# create_versioned_branch(repo, version) if File.directory?(Dir.home + '/workspace/' + repo.gsub(/\w*-?\w*\//,''))
	end	
end

def check_for_branch(repo, version)
	repo = repo.gsub(/\w*-?\w*\//,'')
	
end


# creates 'review' branch for every repo
def create_versioned_branch(repo, version)
	repo = repo.gsub(/\w*-?\w*\//,'')
	puts ""
	puts "Creating #{version} branch for #{repo}"
	`cd ~/workspace/#{repo}; git checkout -b #{version}; git checkout #{version}; git pull; git merge master; git push -u origin #{version}`
end

gather_repos(@books)
