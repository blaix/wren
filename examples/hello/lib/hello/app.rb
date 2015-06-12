require "hello/actions"

module Hello
  class App
    class Router
      class NotFound < StandardError; end

      attr_reader :routes

      def initialize(&block)
        @routes = {}
        instance_eval(&block)
      end

      def resource(name, at:, &block)
        @this_path = at
        routes[@this_path] = {}
        instance_eval(&block)
      end

      def on(req_method, call:)
        routes[@this_path][req_method] = call
      end

      def action_for(path, req_method)
        routes.fetch(path).fetch(req_method)
      rescue KeyError
        raise NotFound.new("Can't find route for #{req_method} #{path}")
      end
    end

    def call(env)
      router = Router.new do
        resource "hello", at: "/hello" do
          on "GET", call: "say_hello"
          on "HEAD", call: "do_nothing"
        end

        resource "world", at: "/world" do
          on "DELETE", call: "say_goodbye"
        end
      end

      path = env.fetch("PATH_INFO")
      req_method = env.fetch("REQUEST_METHOD")

      begin
        action_name = router.action_for(path, req_method)
        action = actions.send(action_name)
        body = action.call
        status = 200
      rescue Router::NotFound
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
