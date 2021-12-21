# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "voltage"
require "active_record"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

ActiveRecord::Schema.define(version: 0) do
  create_table :things do |t|
    t.string :name
    t.timestamps null: false
  end
end

class Thing < ActiveRecord::Base
  include Voltage.active_record

  validates_presence_of :name
end

class MyListener
  %i[validation update create remove].each do |type|
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def before_#{type}(thing); puts __method__; end
      def on_#{type}(thing); puts __method__; end
      def after_#{type}(thing); puts __method__; end
    RUBY
  end
end

puts "\n=== Creating valid record"
thing = Thing.new(name: "Stuff")
thing.listeners << MyListener.new
thing.save

puts "\n=== Creating invalid record"
thing = Thing.new(name: nil)
thing.listeners << MyListener.new
thing.save

puts "\n=== Updating valid record"
thing = Thing.create(name: "Stuff")
thing.listeners << MyListener.new
thing.update_attributes(name: "Updated stuff")

puts "\n=== Updating invalid record"
thing = Thing.create!(name: "Stuff")
thing.listeners << MyListener.new
thing.update_attributes(name: nil)

puts "\n=== Removing record"
thing = Thing.create(name: "Stuff")
thing.listeners << MyListener.new
thing.destroy
