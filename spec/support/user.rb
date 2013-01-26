class User < ActiveRecord::Base
  include Signal::ActiveRecord
  validates_presence_of :username
end
