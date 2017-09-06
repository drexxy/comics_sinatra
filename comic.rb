class Character
	def initialize(arg)
    @arg = arg
	end

  attr_accessor :arg

  def putsIssue
    arg
  end
 
	module ComicLibrary
		comics = YAML.load(File.open("comics.yml"))

		def char
			char = request.path_info.split("s/").last.gsub("-", " ").split("/").first.gsub(/\w+/, &:capitalize)
		end

end

end

# SPAWN = Character.new(character = {:spawn => {:issue1 => ["title_of_spawn", "img_path", "synopsis"]}})

# def SPAWN.title(value1, value2, value3)
# 	arg[value1][value2][value3]

# end

