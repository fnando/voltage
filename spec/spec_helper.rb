require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'bundler/setup'
require 'active_record'

I18n.enforce_available_locales = false

require 'signal'
require 'support/observable'
require 'support/callable'
require 'support/user'

ActiveRecord::Base.establish_connection({
  :adapter => 'sqlite3',
  :database => ':memory:'
})

ActiveRecord::Schema.define(:version => 0) do
  create_table :users do |t|
    t.string :username
  end
end
