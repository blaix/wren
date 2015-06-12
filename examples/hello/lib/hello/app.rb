require "hello/actions"

module Hello
  class App
    class Router
      attr_reader :routes

      def initialize(routes)
        @routes = routes
      end

      def action_for(path, req_method)
        routes.fetch(path).fetch(req_method)
      end
    end

    def call(env)
      routes = {
        "/hello" => {
          "GET" => "say_hello",
          "HEAD" => "do_nothing"
        },
        "/world" => {
          "DELETE" => "say_goodbye"
        }
      }

      router = Router.new(routes)

      path = env.fetch("PATH_INFO")
      req_method = env.fetch("REQUEST_METHOD")

      begin
        action_name = router.action_for(path, req_method)
        action = actions.send(action_name)
        body = action.call
        status = 200
      rescue KeyError
        body = nil
        status = 404
      end

      [status, {}, [body]]
    end

    private

    def actions
      @actions ||= Actions.new
    end
  end
end
