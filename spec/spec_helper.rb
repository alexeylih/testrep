$:.unshift File.expand_path(File.dirname(__FILE__) + "/../lib")

require 'em-hiredis'
require 'router'
require 'model'
require './connection_helper'

RSpec.configure do |config|
  config.include ConnectionHelper
end

def redis
	$redis ||= EM::Hiredis.connect("redis://localhost:6379/9")
end
