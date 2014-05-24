require 'json'

class Record

  include EventMachine::Deferrable

  def initialize(id = nil)
    @id = id
  end

  @@properties = Array.new
  
  attr_accessor :id
  
  def self.property(name)
    @@klass = self.name.downcase

    attr_accessor name
    @@properties.push(name)

    #define async get and set 
    define_method("aget_#{name}") do
       redis.get("#{@@klass}:id:" + id.to_s + ":#{name}").callback{ |res|
       		send("#{name}=", res)	
       }
    end

    define_method("aset_#{name}") do |*args|
       send("#{name}=", args.first)
       redis.set("#{@@klass}:id:" + id.to_s + ":#{name}", args.first)
    end
  end

  def load_async
	redis.multi
	@@properties.each do |prop|
		redis.get("#{@@klass}:id:" + id.to_s + ":#{prop}")
	end 

	redis.exec.callback { |data|
		@@properties.each_with_index do |prop, i|
			send("#{prop}=", data[i])	
		end 
		succeed(self)			
	}

	self
  end 

  def delete_async
  	redis.multi
  	@@properties.each { |prop|
  		redis.del("#{@@klass}:id:" + id.to_s + ":#{prop}")
  	}
  	
  	redis.exec
  end 

end

class Task < Record

	property :description
	property :current_location
	property :destination_location

	def self.create(description, dest_location, curr_location=nil)
		task = Task.new
	    redis.incr("task:id").callback {|task_id|
	    	task.id = task_id

	    	redis.multi
		    	task.aset_description(description)
		    	task.aset_destination_location(dest_location)
		    	task.aset_current_location(curr_location) if curr_location
	    	redis.exec.callback { |a|
	    		task.succeed(task) 
	    	}
	    }

	    task
	end   

	def self.all
		all_tasks = DeferrableResult.new 

		redis.get("task:id").callback{ |last_index|

			EM::Iterator.new(0..last_index.to_i)
				.map(collect_tasks_proc, proc{ |res| 

					all_tasks.result = res.compact
			 		all_tasks.succeed(all_tasks)
			 	})
		}

		all_tasks
	end

	def self.collect_tasks_proc
		Proc.new { |task_id, iterator|
			Task.exists?(task_id).callback { |exists|
				if exists
					task = Task.new(task_id)
					task.load_async.callback {|task|
						iterator.return(task)
					}
				else
					iterator.return
				end
			}
		}
	end

	def update_async(params = {}) 
		redis.multi
	    	aset_description(params[:description]) if params.key? :description
		    aset_destination_location(params[:destination_location]) if params.key? :destination_location
		    aset_current_location(params[:current_location]) if params.key? :current_location
    	redis.exec.callback {
    		succeed(self)	
    	}		
    	self
	end 

	def self.exists?(id)
		puts caller
		found = DeferrableResult.new
		# if mandatory destination_location filed exists, the whole object exists
		redis.exists("task:id:#{id}:destination_location")
		.callback{ |res|
			found.result = !res.zero?
			found.succeed(found)
		}
		.errback { |e| p e } 

		found
	end

	def as_json(options={})
		{
			id: id,
			description: description,
			current_location: current_location,
			destination_location: destination_location
		}
	end

	def self.create_from_json(json_data)
		data = JSON.parse(json_data, :symbolize_names => true)
		Task.create(data[:description], 
			data[:destination_location],
			data[:current_location])
	end

	def update_from_json(json_data)
		data = Task.from_json json_data
		update_async(data)
	end

	private 

	def self.from_json(json_data)
		JSON.parse(json_data, :symbolize_names => true)
	end

end

#defferable wrapper for array  
class DeferrableResult 

	include EventMachine::Deferrable  
	attr_accessor :result

	def initialize *args
	  super
	end
	
end



