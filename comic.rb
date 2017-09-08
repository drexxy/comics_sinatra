class Character

	attr_accessor :comic_series, :issue, :title, :img_path, :synopsis

	def initialize(args)
		args.keys.each do |key|
			instance_variable_set("@#{key}".to_sym, args[key])
		end
	end
end