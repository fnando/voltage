require "spec_helper"

describe "Constant lookup", "https://github.com/fnando/signal/issues/2" do
  let(:callable) { Callable.new }

  it "triggers event" do
    emitter = Emitter.new
    emitter.on(:success, &callable)
    expect(callable).to receive(:called).with(no_args)

    emitter.call
  end
end
