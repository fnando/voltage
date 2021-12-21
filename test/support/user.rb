# frozen_string_literal: true

class User < ActiveRecord::Base
  include Voltage.active_record
  validates_presence_of :username
end
