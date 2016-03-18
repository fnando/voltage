$:.unshift File.expand_path("../../lib", __FILE__)
require "signal"

class Contact
  include Signal.call

  attr_reader :name, :email

  def initialize(name, email)
    @name, @email = name, email
  end

  def call
    emit(:output, self)
  end
end

Contact.call("John", "john@example.com") do |o|
  o.on(:output) {|contact| puts contact.name }
end
