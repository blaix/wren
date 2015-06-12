class Actions
  autoload :SayHello, "hello/actions/say_hello"

  def say_hello
    SayHello.new
  end
end
