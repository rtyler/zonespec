$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '../lib'))

require 'pry'

RSpec.configure do |c|
  c.color = true
  c.order = "random"
end
