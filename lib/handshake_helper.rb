class HandshakeHelper 
	# converts path of requested resource to resource id
	
  class << self

	def dispatch(path)
		HandshakeHelper.parse_path(path)
	end

	def parse_path(path)
		HandshakeHelper.convert_to_number(path.split('/').last)
	end 

	def convert_to_number(object)
	   	Integer(object) rescue nil
  	end

  	def handle(handshake, item_id, socket)
  		handshake.headers['Sec-WebSocket-Protocol'] == "ws_reciever" ? SubscriberHandler.new(item_id, socket) : PublisherHandler.new(item_id, socket)
  	end

  end
	
end