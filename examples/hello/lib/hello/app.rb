module Hello
  class App
    def call(env)
      [200, {}, "Hello, World!"]
    end
  end
end
