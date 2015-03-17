$:.unshift File.expand_path('../../lib', __FILE__)
require 'signal'
require 'active_record'

ActiveRecord::Base.establish_connection({
  :adapter => 'sqlite3',
  :database => ':memory:'
})

ActiveRecord::Schema.define(:version => 0) do
  create_table :things do |t|
    t.string :name
    t.timestamps null: false
  end
end

class Thing < ActiveRecord::Base
  include Signal::ActiveRecord

  validates_presence_of :name
end

thing = Thing.new(:name => 'Stuff')
thing.on(:create) {|model| puts model.updated_at, model.name }
thing.on(:update) {|model| puts model.updated_at, model.name }
thing.on(:remove) {|model| puts model.destroyed? }
thing.on(:validation) {|model| p model.errors.full_messages }

thing.save!
#=> 2013-01-26 10:32:39 -0200
#=> Stuff

thing.update_attributes(:name => 'Updated stuff')
#=> 2013-01-26 10:33:11 -0200
#=> Updated stuff

thing.update_attributes(:name => nil)
#=> ['Name can't be blank']

thing.destroy
#=> true
