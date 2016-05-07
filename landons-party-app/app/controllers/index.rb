
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
  push = JSON.parse(request.body.read)
  erb :payload
end
