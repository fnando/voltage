require 'spec_helper'

describe Signal::Call do
  let(:callable) { Callable.new }

  it 'initializes observable with arguments' do
    observable = ObservableWithCall.call(1, 2, 3) {}
    expect(observable.args).to eq([1, 2, 3])
  end

  it 'triggers event' do
    expect(callable).to receive(:called).with([1, 2, 3])

    ObservableWithCall.call(1, 2, 3) do |o|
      o.on(:args, &callable)
    end
  end
end
