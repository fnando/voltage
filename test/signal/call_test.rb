# frozen_string_literal: true

require "test_helper"

class SignalCallTest < Minitest::Test
  test "initializes observable with arguments" do
    observable = ObservableWithCall.call(1, 2, 3)
    assert_equal [1, 2, 3], observable.args
  end

  test "initializes observable with named arguments" do
    observable = ObservableWithCall.call(a: 1, b: 2, c: 3)
    assert_equal Hash[a: 1, b: 2, c: 3], observable.kwargs
  end

  test "triggers event" do
    callable = Callable.new(:on_args)
    callable.expect(:on_args, nil, [[1, 2, 3], {}])

    ObservableWithCall.call(1, 2, 3) do |o|
      o.on(:args, &callable)
    end

    assert callable.verify
  end
end
