require 'sinatra'
require 'shotgun'
require 'pry'
require './comic.rb'
require 'yaml'
# include ComicLibrary

get '/' do 
	erb :index, :layout => :'layouts/main'
end

get '/comics/:title/?:issue?' do 
	if params['issue']
		erb :issues, :layout => :'layouts/main'
	else
		erb params['title'].gsub("-", "_").to_sym, :layout => :'layouts/characters'
	end
end