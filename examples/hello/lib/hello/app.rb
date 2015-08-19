require "hello/actions"
require "hello/router"

module Hello
  class App
    def call(env)
      router = Hello::Router.new
      path = env.fetch("PATH_INFO")
      req_method = env.fetch("REQUEST_METHOD")

      begin
        action_name = router.action_for(path, req_method)
        action = actions.send(action_name)
        body = action.call
        status = 200
      rescue Wren::Router::NotFound
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
