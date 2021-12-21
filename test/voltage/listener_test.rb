# frozen_string_literal: true

require "test_helper"

class VoltageListenerTest < Minitest::Test
  test "sets string representation" do
    listener = Voltage::Listener.new(self, :on, :ready, &-> { })
    assert_equal "<Voltage::Listener event: on_ready>", listener.to_s
  end
end
