# frozen_string_literal: true

module Voltage
  def self.call
    Extensions::Call
  end

  module Extensions
    module Call
      def self.included(target)
        target.include(Voltage)
        target.extend(ClassMethods)
      end

      module ClassMethods
        def call(*args, **kwargs)
          new(*args, **kwargs).tap do |instance|
            yield(instance) if block_given?
            instance.call
          end
        end
      end
    end
  end
end
