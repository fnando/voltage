# frozen_string_literal: true

class ObservableWithCall
  include Voltage.call

  attr_reader :args, :kwargs

  def initialize(*args, **kwargs)
    @args = args
    @kwargs = kwargs
  end

  def call
    emit(:args, args, kwargs)
  end
end
