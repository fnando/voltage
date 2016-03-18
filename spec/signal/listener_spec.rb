require "spec_helper"

describe Signal::Listener do
  it "sets string representation" do
    listener = Signal::Listener.new(self, :on, :ready, &->{})
    expect(listener.to_s).to eq("<Signal::Listener event: on_ready>")
  end
end
