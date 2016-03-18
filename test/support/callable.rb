class Callable < Minitest::Mock
  def initialize(method_name)
    super()
    @method_name = method_name
  end

  def to_proc
    callable = self
    proc {|*args| callable.send(@method_name, *args) }
  end
end
