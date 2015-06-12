require "hello/actions"

module Hello
  class App
    def call(env)
      body = if env["PATH_INFO"] == "/hello"
        if env["REQUEST_METHOD"] == "GET"
          actions.say_hello.call
        elsif env["REQUEST_METHOD"] == "HEAD"
          actions.do_nothing.call
        end
      elsif env["PATH_INFO"] == "/world"
        if env["REQUEST_METHOD"] == "DELETE"
          actions.say_goodbye.call
        end
      end

      status = body ? 200 : 404
      [status, {}, [body]]
    end

    private

    def actions
      @actions ||= Actions.new
    end
  end
end
