get '/?' do	
	erb :index
end

get	'/book/:book_name' do
	@book = params[:book_name]
	b = Book.new(@book)
	@repos = b.get_repos.sort!
	@vars = b.get_vars
	erb :book
end

get '/book/:book_name/repo/:repo_name' do
	@book = params[:book_name]
	@repo = params[:repo_name]
	r = Repo.new(@repo, @book)
	@monster_hash = r.get_info
	erb :repo
end

post '/payload' do
  @push = JSON.parse(request.body.read)
  @push = @push["commits"][0]["id"]

  client = Octokit::Client.new :access_token => 'b28264d44885ca48e60db55d128654ed06fed267'
  # client.create_issue("ljarzynski/asdf", 'Update pre-release', 'The following commit was made to master: ' + @push)
  pre_release_hash = client.refs("ljarzynski/asdf")
  pre_release_hash.each do |i|
  	if i[:ref] == "refs/heads/pre-release"
  		@pre_release_sha = i[:object][:sha]
  	end
  end
  
  client.create_ref("ljarzynski/asdf", "refs/heads/test4", @pre_release_sha)
  client.merge("ljarzynski/asdf", "refs/heads/test4", @push)
  client.create_pull_request("ljarzynski/asdf", "refs/heads/pre-release", "refs/heads/test4", "test")
  erb :payload
end
