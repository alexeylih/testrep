class Router 
	# converts path of requested resource to resource id
	
	def self.dispatch(path)
		Router.parse_path(path)
	end

	def self.parse_path(path)
		if path.length < 2 
			return nil
		end

		#we assume that id is a number
		id = path[1, path.length - 1]
		Router.convert_to_number(id)
	end 

	def self.convert_to_number(object)
	   	Integer(object) rescue nil
  	end

end