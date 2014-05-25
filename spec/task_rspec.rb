require './spec_helper'

describe Task do 

	#Task functional tests

	it "creates task from parameters and stores it" do
		EventMachine.run {
			sig = EventMachine.start_server("0.0.0.0", "3001")
			Task.create("Bring pizza to Sam", "32,32", "42,42").callback {
				expect_task_to(1, ["1", "Bring pizza to Sam", "32,32", "42,42"])
				p "stopping"
				EventMachine.stop_server sig
			}
		}
 	  end

	  it "deletes task" do
			EventMachine.run {
				redis.flushdb
				sig = EventMachine.start_server("0.0.0.0", "3001")
				Task.create("Bring pizza to Sam", "32,32", "42,42").callback {
					Task.new(1).delete_async.callback { |res|
						expect_task_to(1, ["1", nil, nil, nil], sig)	
					}
				}
		}
 	  end

    def expect_task_to(task_id, expectation, sig)
    	redis.multi
    	redis.get("task:id")
		redis.get("task:id:#{task_id}:description")
		redis.get("task:id:#{task_id}:current_location")
		redis.get("task:id:#{task_id}:destination_location")
		redis.exec.callback{ |res|
			expect(res).to match_array expectation 
		}

		EventMachine.stop_server sig
    end 

end


