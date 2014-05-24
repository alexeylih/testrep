require 'active_support/all'
require 'sinatra'
require 'lib/status_helper'

class AsyncRestServer < Sinatra::Base
  register Sinatra::Async
  include StatusHelper
  
	aget '/api/tasks/' do 
  		Task.all.callback { |all_tasks|
  			body all_tasks.result.to_json
		}
	end


  aget '/api/tasks/:n' do |n|
	Task.exists?(n).callback { |found|
		if found.result
			task = Task.new(n)
			task.load_async.callback { 
				body task.to_json
			}
		else
			not_found
		end
	}	
  end

  apost '/api/tasks/' do 
	if !params[:data]
		bad_request
	end 

	Task.exists?(n).callback { |found|
		if found.result
			Task.new(n)
				.update_from_json(params[:data])
				.callback{ |res| body res.to_json }
		else
			not_found
		end
	}
  end

  aput '/api/tasks/:n' do |n|
	if params[:data]
		Task.create_from_json(params[:data]).callback { |res| body res.to_json }
	else
		bad_request
	end
  end

  aget '/' do
  	begin
  		p settings.public_folder
	  	# somhow must change this to non-blocking fs read
	  	body File.read('public/index.html')
  	rescue Exception => e   
  		p e
  	end 
  end


end