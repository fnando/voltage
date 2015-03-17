$:.unshift File.expand_path('../../lib', __FILE__)
require 'signal'

class Contact
  include Signal

  attr_reader :name, :email

  def initialize(name, email)
    @name, @email = name, email
  end

  def output!
    emit(:output, self)
  end
end

contact = Contact.new('John Doe', 'john@example.org')
contact.on(:output) {|contact| puts contact.name, contact.email }
contact.output!
