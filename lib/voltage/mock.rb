# frozen_string_literal: true

module Voltage
  class Mock
    def calls
      @calls ||= []
    end

    def method_missing(name, *args)
      return super unless respond_to_missing?(name)

      calls << {event: name.to_s.gsub(/^on_/, "").to_sym, args: args}
    end

    def respond_to_missing?(name, _include_all = false)
      name =~ /^on_/
    end

    def received?(event, options = {})
      received_event?(event, options[:times] || -1) &&
        received_with?(event, options[:with])
    end

    def to_proc
      proc {|action| action.add_listener(self) }
    end

    def on(event)
      proc {|*args| calls << {event: event, args: args} }
    end

    private def received_event?(event, count)
      received_calls = calls.count {|call| call[:event] == event }

      return received_calls.nonzero? if count == -1

      received_calls == count
    end

    private def received_with?(event, args)
      return true unless args

      calls.any? do |call|
        next unless call[:event] == event
        next args.call(call[:args]) if args.is_a?(Proc)

        args == call[:args]
      end
    end
  end
end
