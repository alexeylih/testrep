$LOAD_PATH << '.'
require 'eventmachine'
require 'em-websocket'
require 'em-hiredis'
require 'json'
require 'sinatra/async'
require 'thin'
require 'restful'
require 'lib/handshake_helper'
require 'lib/model'
require 'lib/status_helper'
require 'lib/connection_handlers'

EventMachine.run do

	def redis
		$redis ||= EM::Hiredis.connect("redis://redistogo:c5c119ec95f29c20886bcf5a7f7a6f2f@angelfish.redistogo.com:10023/")
	end

	EventMachine::WebSocket.run(host: "0.0.0.0", port: 8080) do |socket|

    socket.onopen do |handshake|

	  item_id = HandshakeHelper.dispatch handshake.path

	  if item_id 
	  	@connection_handler = HandshakeHelper.handle(handshake, item_id, socket)
	  else
	  	error = { error_code: 404 }
	  	socket.send error.to_json
	  	socket.close
	  end

	end

    socket.onclose do
     	@connection_handler.onclose if @connection_handler
 	end

    socket.onmessage do |msg|
      	@connection_handler.onmessage(msg)
    end

  end

  EventMachine.error_handler { |err| puts err }

  AsyncRestServer.run! 

end