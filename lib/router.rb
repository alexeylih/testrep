class Router 
	# converts path of requested resource to resource id
	
	def self.dispatch(path)
		Router.parse_path(path)
	end

	def self.parse_path(path)
		Router.convert_to_number(path.split('/').last)
	end 

	def self.convert_to_number(object)
	   	Integer(object) rescue nil
  	end

end