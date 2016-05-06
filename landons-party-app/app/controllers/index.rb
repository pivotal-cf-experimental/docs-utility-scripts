get '/?' do	
	erb :index
end

get	'/book/:book_name' do
	@book = params[:book_name]
	erb :book
end

