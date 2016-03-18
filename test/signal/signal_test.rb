require "test_helper"

class AddListenerTest < Minitest::Test
  let(:observable) { Observable.new }
  let(:callable) { Callable.new(:on_ready) }

  test "runs listener" do
    callable.expect(:on_ready, nil, [])
    observable.add_listener(callable)

    observable.emit(:ready)

    assert callable.verify
  end

  test "returns itself" do
    assert_equal observable, observable.add_listener(callable)
  end
end

class UsingBlocksTest < Minitest::Test
  let(:observable) { Observable.new }
  let(:callable) { Callable.new(:on_ready) }

  test "triggers event" do
    callable.expect(:on_ready, nil, [])
    observable.on(:ready, &callable)

    observable.emit(:ready)

    assert callable.verify
  end

  test "triggers event with arguments" do
    callable.expect(:on_ready, nil, [1, 2, 3])
    observable.on(:ready, &callable)

    observable.emit(:ready, 1, 2, 3)

    assert callable.verify
  end

  test "triggers before event" do
    callable = Callable.new(:before_ready)
    callable.expect(:before_ready, nil, [])
    observable.before(:ready, &callable)

    observable.emit(:ready)

    assert callable.verify
  end

  test "triggers before event with arguments" do
    callable = Callable.new(:before_ready)
    callable.expect(:before_ready, nil, [1, 2, 3])
    observable.before(:ready, &callable)

    observable.emit(:ready, 1, 2, 3)

    assert callable.verify
  end

  test "triggers after event" do
    callable = Callable.new(:after_ready)
    callable.expect(:after_ready, nil, [])
    observable.after(:ready, &callable)

    observable.emit(:ready)

    assert callable.verify
  end

  test "triggers after event with arguments" do
    callable = Callable.new(:after_ready)
    callable.expect(:after_ready, nil, [1, 2, 3])
    observable.after(:ready, &callable)

    observable.emit(:ready, 1, 2, 3)

    assert callable.verify
  end

  test "chains events" do
    calls = []

    observable
      .before(:ready) { calls << :before }
      .on(:ready) { calls << :on }
      .after(:ready) { calls << :after }

    observable.emit(:ready)

    assert_equal %i[before on after], calls
  end

  test "keeps context" do
    context = nil
    callable = -> { context = self }
    observable.on(:ready, &callable)
    observable.emit(:ready)

    assert_equal self, context
  end
end

class UsingListenersTest < Minitest::Test
  let(:observable) { Observable.new }
  let(:callable) { Callable.new(:on_ready) }

  test "triggers event for listener" do
    observable.listeners << callable
    callable.expect(:after_ready, nil, [])

    observable.emit(:ready)

    assert callable.verify
  end

  test "triggers event for listener with arguments" do
    observable.listeners << callable
    callable.expect(:after_ready, nil, [1, 2, 3])

    observable.emit(:ready, 1, 2, 3)

    assert callable.verify
  end
end

class MixedListenersTest < Minitest::Test
  test "calls all listeners" do
    observable = Observable.new
    callable = Callable.new(:on_ready)
    another_callable = Callable.new(:on_ready)

    callable.expect(:on_ready, nil, [])
    another_callable.expect(:on_ready, nil, [])

    observable
      .add_listener(callable)
      .on(:ready, &another_callable)
      .emit(:ready)

    assert callable.verify
    assert another_callable.verify
  end
end
