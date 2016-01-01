module Wren
  class App
    attr_reader :router, :actions

    def initialize(router, actions)
      @router = router
      @actions = actions
    end

    def call(env)
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
  end
end

