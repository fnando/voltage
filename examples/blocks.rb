$:.unshift File.expand_path("../../lib", __FILE__)
require "signal"

class Status
  include Signal

  def ready!
    emit(:ready)
  end
end

status = Status.new
status.before(:ready) { puts "Before the ready event!" }
status.on(:ready) { puts "I'm ready!" }
status.after(:ready) { puts "After the ready event!" }
status.ready!
