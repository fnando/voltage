# frozen_string_literal: true

class Emitter
  include Signal

  def call
    ActiveRecord::Base.transaction do
      emit(:success)
    end
  end
end
