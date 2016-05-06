require 'sinatra'
require 'json'

get '/?' do	
	erb :index
end

get	'/book/:book_name' do
	@book = params[:book_name]
	erb :book
end

get '/repo/:repo_name' do
	@repo = params[:repo_name]
	erb :repo
end

post '/payload' do
  push = JSON.parse(request.body.read)
end
