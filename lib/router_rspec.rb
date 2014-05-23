require './router'

describe Router, "self.dispatch" do 
	it "returns nil for invalid path (non /1 format path) " do 
		expect(Router.dispatch("invalid path")).to be_nil
	end

	it "returns resource id for valid path" do 
		expect(Router.dispatch("/1")).to be(1)
	end
	
end