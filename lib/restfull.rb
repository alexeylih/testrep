require 'active_support/all'

class AsyncRestServer < Sinatra::Base
  register Sinatra::Async
  
  enable :show_exceptions

	aget '/' do 
  		Task.all.callback { |all_tasks|
  			body all_tasks.result.to_json
		}
	end


  aget '/:n' do |n|
  	
	Task.exists?(n).callback { |res|
	if res
		task = Task.new(n)
		task.load_async.callback { 
			p task.description
			body task.to_json
		}
	else
		# 404
	end
	}	
  end

  apost '/:n' do |n|
	if !params[:data]
		# 403
	end 

	Task.exists?(n).callback { |res|
		if res
			Task.new(n).update_from_json(params[:data]).callback{ |a| body "1"}
		end
	}
  end

  aput '/:n' do |n|
	if params[:data]
		Task.create_from_json(params[:data]).callback { |a| body a.to_json }
	end
  end

  aget '/sender/' do
  	begin
	  	# somhow should change this to unblocking fs read
	  	body File.read('public/client.html')
  	rescue Exception => e   
  		p e
  	end 
  end





end