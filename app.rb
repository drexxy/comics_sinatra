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
	@title = params['series']
	if params['issue']
		@issue = params['issue']
		@comic_show = YAML.load_stream(File.open('./comics.yml'))
		binding.pry
		if @issue == "issue-#{@comic_show.issue}" && @title.capitalize == @comic_show.comic_series
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
	File.open('./comics.yml', 'a') { |f| f.write @comic.to_yaml }
  redirect '/add'
end	