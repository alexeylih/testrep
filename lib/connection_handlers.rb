class ConnectionHandler 

	def initialize(resource_id, socket)
		@resource_id, @socket = resource_id, socket
		
	end

	def onmessage(msg)
		#igore incoming messages
	end

	def onclose
	end
	
end

class PublisherHandler < ConnectionHandler

	def onmessage(message)
		update_item(message)
	end 

	private 

	def update_item(val)
		redis.set resource, val
    end 
	
end 

class SubscriberHandler < ConnectionHandler

	def initialize(resource_id, socket)
		super(resource_id, socket)
		EventMachine::PeriodicTimer.new(1, method(:send_update))
	end

	private

	def send_update
		Task.exists?(@resource_id).callback { |res|
			if res
				task = Task.new(@resource_id)
				task.aget_description.callback { |desc|
					@socket.send desc
				}	
			end
		}
		
	end

end