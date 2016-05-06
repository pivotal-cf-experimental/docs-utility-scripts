
get '/?' do	
	erb :index
end

get	'/book/:book_name' do
	@book = params[:book_name]
	b = Book.new(@book)
	@repos = b.get_repos
	@vars = b.get_vars
	erb :book
end

get '/repo/:repo_name' do
	@repo = params[:repo_name]
	erb :repo
end

post '/payload' do
  push = JSON.parse(request.body.read)
  puts push
end
