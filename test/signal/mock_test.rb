# frozen_string_literal: true

require "test_helper"

class MockTest < Minitest::Test
  test "initializes with no calls" do
    mock = Signal::Mock.new

    assert mock.calls.empty?
  end

  test "traps all signals" do
    mock = Signal::Mock.new

    observable = Observable.new
    observable.add_listener(mock)

    observable.emit(:a)
    observable.emit(:b)

    assert_equal 2, mock.calls.size
    assert mock.received?(:a)
    assert mock.received?(:b)
  end

  test "received with count" do
    mock = Signal::Mock.new

    observable = Observable.new
    observable.add_listener(mock)

    observable.emit(:a)
    observable.emit(:a)

    assert_equal 2, mock.calls.size
    assert mock.received?(:a, times: 2)
  end

  test "used as a block for Signal.call" do
    mock = Signal::Mock.new
    ObservableWithCall.call(&mock)

    assert_equal 1, mock.calls.size
    assert mock.received?(:args)
  end

  test "used as a block for Signal.call with arguments" do
    mock = Signal::Mock.new
    ObservableWithCall.call(1, 2, 3, &mock)

    assert_equal 1, mock.calls.size
    assert mock.received?(:args)
    assert_equal [1, 2, 3], mock.calls.first[:args]
  end

  test "received with args" do
    mock = Signal::Mock.new

    observable = Observable.new
    observable.add_listener(mock)

    observable.emit(:a, 1, 2, 3)

    assert_equal 1, mock.calls.size
    assert mock.received?(:a)
    assert_equal [1, 2, 3], mock.calls.first[:args]
  end

  test "using `on`" do
    mock = Signal::Mock.new

    observable = Observable.new
    observable.on(:a, &mock.on(:a))

    observable.emit(:a, 1, 2, 3)

    assert_equal 1, mock.calls.size
    assert mock.received?(:a)
    assert_equal [1, 2, 3], mock.calls.first[:args]
  end

  test "received with args validation" do
    mock = Signal::Mock.new

    observable = Observable.new
    observable.add_listener(mock)

    observable.emit(:a, 1, 2, 3)

    assert_equal 1, mock.calls.size
    assert mock.received?(:a, with: [1, 2, 3])
  end

  test "received with args validation through callable" do
    mock = Signal::Mock.new

    observable = Observable.new
    observable.add_listener(mock)

    observable.emit(:a, 1, 2, 3)

    assert_equal 1, mock.calls.size
    assert mock.received?(:a, with: ->(args) { args == [1, 2, 3] })
  end
end
