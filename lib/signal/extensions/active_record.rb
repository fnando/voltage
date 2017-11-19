# frozen_string_literal: true

module Signal
  def self.active_record
    Extensions::ActiveRecord
  end

  module Extensions
    module ActiveRecord
      def self.included(base)
        base.class_eval do
          include Signal

          around_create     :around_create_signal
          around_save       :around_save_signal
          around_destroy    :around_destroy_signal
          before_validation :before_validation_signal
          after_validation  :after_validation_signal
        end
      end

      private

      def around_create_signal
        emit_signal(:before, :create, self)
        yield
        return unless persisted?
        emit_signal(:on, :create, self)
        emit_signal(:after, :create, self)
      end

      def around_save_signal
        if new_record?
          yield
          return
        end

        emit_signal(:before, :update, self)
        yield
        emit_signal(:on, :update, self)
        emit_signal(:after, :update, self)
      end

      def around_destroy_signal
        emit_signal(:before, :remove, self)
        yield
        emit_signal(:on, :remove, self)
        emit_signal(:after, :remove, self)
      end

      def before_validation_signal
        emit_signal(:before, :validation, self)
      end

      def after_validation_signal
        emit_signal(:on, :validation, self) if errors.any?
        emit_signal(:after, :validation, self)
      end
    end
  end
end
