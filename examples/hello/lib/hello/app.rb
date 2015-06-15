require "hello/actions"

module Hello
  class App
    class Router
      class NotFound < StandardError; end

      attr_reader :resources

      class Resource
        attr_reader :actions

        def initialize(name, &block)
          @actions = {}
          instance_eval(&block)
        end

        def on(req_method, call:)
          actions[req_method] = call
        end

        def action_for(req_method)
          actions.fetch(req_method)
        end
      end

      def initialize(&block)
        @resources = {}
        instance_eval(&block)
      end

      def resource(name, at:, &block)
        resources[at] = Resource.new(name, &block)
      end

      def action_for(path, req_method)
        resources.fetch(path).action_for(req_method)
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
