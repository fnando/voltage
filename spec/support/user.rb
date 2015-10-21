class User < ActiveRecord::Base
  include Signal.active_record
  validates_presence_of :username
end
