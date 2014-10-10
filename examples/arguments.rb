$:.unshift File.expand_path('../../lib', __FILE__)
require 'signal'

class Arguments
  include Signal
end

class MyListener
  def on_args(a, b)
    puts a, b
  end
end

args = Arguments.new
args.on(:args) {|a, b| puts a, b }
args.listeners << MyListener.new
args.emit(:args, 1, 2)
