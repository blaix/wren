module Hello
  class Actions
    autoload :SayHello, "hello/actions/say_hello"
    autoload :SayGoodbye, "hello/actions/say_goodbye"

    def say_hello
      SayHello.new
    end

    def say_goodbye
      SayGoodbye.new
    end

    def do_nothing
      -> { "" }
    end
  end
end
