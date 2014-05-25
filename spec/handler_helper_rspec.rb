require './spec_helper'

describe HandshakeHelper, "self.dispatch" do 
	it "returns nil for invalid path (non /1 format path) " do 
		expect(HandlerHelper.dispatch("invalid path")).to be_nil
	end

	it "returns resource id for valid path" do 
		expect(HandlerHelper.dispatch("/1")).to be(1)
	end
	
end