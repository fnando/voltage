$:.unshift File.expand_path("../../lib", __FILE__)
require "signal"

class Status
  include Signal

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
