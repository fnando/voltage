# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "voltage"

class Arguments
  include Voltage
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
