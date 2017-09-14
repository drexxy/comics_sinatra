require 'sinatra/flash'

class Comic

	attr_accessor :id, :comic_series, :issue, :title, :img_path, :synopsis

	def initialize(args)
		args.keys.each do |key|
			instance_variable_set("@#{key}".to_sym, args[key])
		end
	end

	def save 
		db = SQLite3::Database.new("comics.db")
		db.execute("INSERT INTO comics (comic_series, issue_number, title, img_path, synopsis)
	 						VALUES (?, ?, ?, ?, ?)", [@comic_series, @issue, @title, @img_path, @synopsis])
  	result = db.execute("SELECT * FROM comics ORDER BY(ID) DESC LIMIT 1")
	end

 
  def self.find(id)
  	db = SQLite3::Database.new("comics.db")
  	findings = db.execute("SELECT * FROM comics WHERE ID = ?",
  											id)
  	self.new(id: findings[0][0],
						comic_series: findings[0][1], 
						issue: findings[0][2], 
						title: findings[0][3], 
						img_path: findings[0][4], 
						synopsis: findings[0][5])
  end

  def update(id, column, new_info)
  	db = SQLite3::Database.new("comics.db")
  	db.execute("UPDATE comics SET ID = :new_info WHERE id = :id",
  							"new_info" => new_info,
  							"id" => id)
  end

  def delete
  	db = SQLite3::Database.new("comics.db")
  	delete_comic = Comic.find(id)
  	db.execute("DELETE FROM comics WHERE id = ?",
  							delete_comic.id)
  end

end

