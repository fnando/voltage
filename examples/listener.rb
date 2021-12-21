# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "voltage"

class Status
  include Voltage

  def ready!
    emit(:ready)
  end
end

class MyListener
  def before_ready
    puts "Before the ready event!"
  end

  def on_ready
    puts "I'm ready!"
  end

  def after_ready
    puts "After the ready event!"
  end
end

status = Status.new
status.listeners << MyListener.new
status.ready!
