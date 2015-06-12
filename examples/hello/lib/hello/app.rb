require "hello/actions/say_hello"

module Hello
  class App
    def call(env)
      [200, {}, SayHello.new.call]
    end
  end
end
