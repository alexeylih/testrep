module ConnectionHelper
  # Use db 9 for tests to avoid flushing the main db
	def connect
	  	@a = EventMachine.run do
	  		redis.flushdb
	    	yield
		end
  	end
end