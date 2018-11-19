# Use this branch, the 'review' branch, to idempotently delete and recreate review branches off of master for all repos listed in the config.yml files of the four docs books: OSS, PWS, core & services. If this branch is checked out, just run `update` from CL.

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
	@repo_list.delete('cloudfoundry/uaa')
	review_check @repo_list.uniq
end

def review_check(repo_list)
	repo_list.each do |repo|
		create_review_branch(repo) if File.directory?(Dir.home + '/workspace/' + repo.gsub(/\w*-?\w*\//,''))
	end	
end

# creates 'review' branch for every repo
def create_review_branch(repo)
	repo = repo.gsub(/\w*-?\w*\//,'')
	puts ""
	puts "Deleting old and creating new review branch for #{repo}"
	`cd ~/workspace/#{repo}; git checkout master; git branch -d review; git push origin --delete review; git branch review; git push -u origin review`
end

gather_repos(@books)
