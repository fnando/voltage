require "test_helper"

# https://github.com/fnando/signal/issues/2
class ConstantLookupTest < Minitest::Test
  let(:callable) { Callable.new(:on_success) }

  test "triggers event" do
    emitter = Emitter.new
    emitter.on(:success, &callable)
    callable.expect(:on_success, nil, [])
    emitter.call

    assert callable.verify
  end
end
