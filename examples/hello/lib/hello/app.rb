require "hello/actions"

module Hello
  class App
    def call(env)
      if env["PATH_INFO"] == "/hello"
        [200, {}, actions.say_hello.call]
      else
        [404, {}, ""]
      end
    end

    private

    def actions
      @actions ||= Actions.new
    end
  end
end
