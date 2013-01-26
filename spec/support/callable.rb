class Callable
  def to_proc
    callable = self
    proc {|*args| callable.called(self, *args) }
  end

  def respond_to(method_name)
    define_singleton_method(method_name, &to_proc)
  end
end
