require "hello/actions"

module Hello
  class App
    def call(env)
      [200, {}, actions.say_hello.call]
    end

    private

    def actions
      @actions ||= Actions.new
    end
  end
end
