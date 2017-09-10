require 'sinatra'
require 'shotgun'
require 'pry'
require './comic.rb'
require 'yaml'
require 'sinatra/flash'

enable :sessions

get '/' do 
	erb :index, :layout => :'layouts/main'
end

get '/comics/:series/?:issue?' do
	@series = params['series']
	if params['issue']
		@issue = params['issue']
		@comic_show = YAML.load_stream(File.open("./#{@series}.yml"))
		@comic_show.select! { |c| c.issue == @issue}
		erb :issues, :layout => :'layouts/main'
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
	@comic = Character.new(comic_series: params['comic-series'], issue: params['issue'], title: params['title'], img_path: params['image-path'], synopsis: params['synopsis'])
	@yaml_name = params['comic-series'].downcase.gsub(" ", "-")
	File.open("./#{@yaml_name}.yml", 'a') { |f| f.write @comic.to_yaml }
  redirect '/add'
end	