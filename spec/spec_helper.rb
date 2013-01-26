require "bundler"
Bundler.setup

require "active_record"

require "signal"
require "support/observable"
require "support/callable"
require "support/user"

ActiveRecord::Base.establish_connection({
  :adapter => "sqlite3",
  :database => ":memory:"
})

ActiveRecord::Schema.define(:version => 0) do
  create_table :users do |t|
    t.string :username
  end
end
