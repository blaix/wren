require "hello/actions"

module Hello
  class App
    def call(env)
      if env["PATH_INFO"] == "/hello"
        if env["REQUEST_METHOD"] == "GET"
          return [200, {}, actions.say_hello.call]
        end
      end

      [404, {}, ""]
    end

    private

    def actions
      @actions ||= Actions.new
    end
  end
end
