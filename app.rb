require 'sinatra'
require 'shotgun'
require 'pry'
require './comic.rb'
require 'yaml'
require 'sinatra/flash'
require 'sqlite3'

enable :sessions

get '/' do 
	erb :index, :layout => :'layouts/main'
end

get '/comics/:series/?:issue?' do
	@series = params['series']
	if params['issue']
		@issue = params['issue']
		db = SQLite3::Database.new("comics.db")
		result = db.execute("select * from comics WHERE comic_series = :series  and issue_number = :number",
								@series.capitalize,
								@issue)
		if result.empty?
			redirect "/"
		else
			@comic_show = Comic.new(id: result[0][0],
														comic_series: result[0][1], 
														issue: result[0][2], 
														title: result[0][3], 
														img_path:result[0][4], 
														synopsis: result[0][5])
			erb :issues, :layout => :'layouts/main'
		end
	else
		erb :characters, :layout => :'layouts/main'
	end
end

get '/add' do
	if session[:signed_in]
		erb :add_comic, :layout => :'layouts/main'
	else
		redirect '/login'
	end
end

get '/delete' do
	if session[:signed_in]
		erb :delete, :layout => :'layouts/main'
	else
		redirect '/login'
	end
end

get '/edit' do
	if session[:signed_in]
		erb :edit, :layout => :'layouts/main'
	else
		redirect '/login'
	end
end

post '/edit' do
	db = SQLite3::Database.new("comics.db")
  db.execute("UPDATE comics SET ID = :idedit,
																comic_series = :comicseries,
																title = :title,
																issue_number = :issuenumber,	
																img_path = :imgpath,
																synopsis = :synopsis 
																WHERE id = :id",
																"id" => params['static-id'],
																"idedit" => params['id'],
              									"comicseries" => params['comic-series'],
              									"title" => params['title'],
              									"issuenumber" => params['issue-number'],
              									"imgpath" => params['image-path'],
              									"synopsis" => params['synopsis'])
  redirect "/"              								
end

get '/search' do
	if session[:signed_in]
		erb :search, :layout => :'layouts/main'
	else
		redirect '/login'
	end
end

post '/search' do
	@comic_edit = Comic.find(params['id-search'])
	erb :edit, :layout => :'layouts/main'
end

get '/login' do
	erb :login, :layout => :'layouts/main'
end

post '/login' do
	if params['username'] == "ben" && params['password'] == "password"
		session[:signed_in] = true
		redirect '/add'
	else
		flash[:signed_in] = true
		redirect '/login'
	end
end

post '/add' do
	@comic = Comic.new(comic_series: params['comic-series'],
										 issue: params['issue'],
										 title: params['title'], 
										 img_path: params['image-path'], 
										 synopsis: params['synopsis'])
	@comic.save
	flash[:added] = true
	redirect '/add'
end	

get '/db' do
 db = SQLite3::Database.new("comics.db")
 db.execute <<-SQL
  create table IF NOT EXISTS comics (
    ID INTEGER PRIMARY KEY NOT NULL,
    comic_series varchar,
    issue_number int,
    title varchar,
    img_path varchar,
    synopsis varchar
  );
	SQL

  new_one =	Comic.find(1)

	 db.execute("select * from comics") do |row|
	 	p row
	 end

 redirect "/"
end