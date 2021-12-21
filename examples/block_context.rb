# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "voltage"

class Contact
  include Voltage

  attr_reader :name, :email

  def initialize(name, email)
    @name = name
    @email = email
  end

  def output!
    emit(:output, self)
  end
end

contact = Contact.new("John Doe", "john@example.org")
contact.on(:output) {|c| puts c.name, c.email }
contact.output!
