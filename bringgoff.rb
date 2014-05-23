$LOAD_PATH << '.'
require 'eventmachine'
require 'em-websocket'
require 'em-hiredis'
require 'json'
require 'yaml'
require 'sinatra/async'
require 'thin'
require 'lib/router'
require 'lib/model'
require 'lib/restfull'


class ConnectionManager 

	def initialize
		@connections = Hash.new 
	end 

	def add_connection(task_id, connection)
		@connections[task_id] = connection
	end
end 

EventMachine.run do

	# def redis
	# 	$redis ||= EM::Hiredis.connect
	# end

	# @connection_manager = ConnectionManager.new

	# EventMachine::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |socket|

 #    socket.onopen do |handshake|
	
	#   item_id = Router.dispatch(handshake.path)

	#   if item_id 
	#   	@connection_handler = SubscriberHandler.new(item_id, socket)
	#   else
	#   	error = { error_code: 404 }
	#   	socket.send error.to_json
	#   	socket.close
	#   end

	# end

 #    socket.onclose do
 #     	@connection_handler.onclose
 # 	end

 #    socket.onmessage do |msg|
 #      	@connection_handler.onmessage(msg)
 #    end

 #  end

  AsyncRestServer.run!

end


