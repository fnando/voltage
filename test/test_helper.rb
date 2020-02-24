# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "bundler/setup"
require "active_record"

I18n.enforce_available_locales = false

require "minitest/utils"
require "minitest/autorun"

require "signal"
require "signal/mock"
require "support/observable"
require "support/observable_with_call"
require "support/user"
require "support/callable"
require "support/emitter"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

ActiveRecord::Schema.define(version: 0) do
  create_table :users do |t|
    t.string :username
  end
end
