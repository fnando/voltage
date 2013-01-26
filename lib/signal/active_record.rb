module Signal
  module ActiveRecord
    def self.included(base)
      base.class_eval do
        include Signal
        include InstanceMethods

        around_create     :around_create_signal
        around_save       :around_save_signal
        around_destroy    :around_destroy_signal
        before_validation :before_validation_signal
        after_validation  :after_validation_signal
      end
    end

    module InstanceMethods
      private
      def around_create_signal
        emit_signal(:before, :create)
        yield
        return unless persisted?
        emit_signal(:on, :create)
        emit_signal(:after, :create)
      end

      def around_save_signal
        if new_record?
          yield
          return
        end

        emit_signal(:before, :update)
        yield
        emit_signal(:on, :update)
        emit_signal(:after, :update)
      end

      def around_destroy_signal
        emit_signal(:before, :remove)
        yield
        emit_signal(:on, :remove)
        emit_signal(:after, :remove)
      end

      def before_validation_signal
        emit_signal(:before, :validation)
      end

      def after_validation_signal
        emit_signal(:on, :validation) if errors.any?
        emit_signal(:after, :validation)
      end
    end
  end
end
