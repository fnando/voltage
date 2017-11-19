# frozen_string_literal: true

require "test_helper"

class SignalListenerTest < Minitest::Test
  test "sets string representation" do
    listener = Signal::Listener.new(self, :on, :ready, &-> { })
    assert_equal "<Signal::Listener event: on_ready>", listener.to_s
  end
end
