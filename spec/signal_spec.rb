require "spec_helper"

describe Signal do
  let(:observable) { Observable.new }
  let(:callable) { Callable.new }

  context "using blocks" do
    it "triggers event" do
      observable.on(:ready, &callable)
      callable.should_receive(:called).with(observable)

      observable.emit(:ready)
    end

    it "triggers event with arguments" do
      observable.on(:ready, &callable)
      callable.should_receive(:called).with(observable, 1, 2, 3)

      observable.emit(:ready, 1, 2, 3)
    end

    it "triggers before event" do
      observable.before(:ready, &callable)
      callable.should_receive(:called).with(observable)

      observable.emit(:ready)
    end

    it "triggers before event with arguments" do
      observable.before(:ready, &callable)
      callable.should_receive(:called).with(observable, 1, 2, 3)

      observable.emit(:ready, 1, 2, 3)
    end

    it "triggers after event" do
      observable.after(:ready, &callable)
      callable.should_receive(:called).with(observable)

      observable.emit(:ready)
    end

    it "triggers after event with arguments" do
      observable.after(:ready, &callable)
      callable.should_receive(:called).with(observable, 1, 2, 3)

      observable.emit(:ready, 1, 2, 3)
    end

    it "chains events" do
      before_callable = Callable.new
      on_callable = Callable.new
      after_callable = Callable.new

      observable
        .before(:ready, &before_callable)
        .on(:ready, &on_callable)
        .after(:ready, &after_callable)

      before_callable.should_receive(:called).with(observable).ordered
      on_callable.should_receive(:called).with(observable).ordered
      after_callable.should_receive(:called).with(observable).ordered

      observable.emit(:ready)
    end
  end

  context "using listeners" do
    it "triggers event for listener" do
      callable.respond_to(:on_ready)
      observable.listeners << callable
      callable.should_receive(:called).with(callable)

      observable.emit(:ready)
    end

    it "triggers event for listener with arguments" do
      callable.respond_to(:on_ready)
      observable.listeners << callable
      callable.should_receive(:called).with(callable, 1, 2, 3)

      observable.emit(:ready, 1, 2, 3)
    end
  end
end
