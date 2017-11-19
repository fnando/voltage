# frozen_string_literal: true

require "signal/version"
require "signal/listener"
require "signal/extensions/active_record"
require "signal/extensions/call"

module Signal
  def on(event, &block)
    listeners << Listener.new(self, __method__, event, &block)
    self
  end

  def before(event, &block)
    listeners << Listener.new(self, __method__, event, &block)
    self
  end

  def after(event, &block)
    listeners << Listener.new(self, __method__, event, &block)
    self
  end

  def add_listener(listener)
    listeners << listener
    self
  end

  def emit(event, *args)
    emit_signal(:before, event, *args)
    emit_signal(:on, event, *args)
    emit_signal(:after, event, *args)
    nil
  end

  def listeners
    @listeners ||= []
  end

  private

  def emit_signal(type, event, *args)
    listeners.each do |listener|
      method_name = "#{type}_#{event}"
      listener.send(method_name, *args) if listener.respond_to?(method_name, true)
    end
  end
end
