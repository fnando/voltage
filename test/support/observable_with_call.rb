# frozen_string_literal: true

class ObservableWithCall
  include Signal.call

  attr_reader :args

  def initialize(*args)
    @args = args
  end

  def call
    emit(:args, *@args)
  end
end
