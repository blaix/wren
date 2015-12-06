require "wren/app"

require "hello/actions"
require "hello/router"

module Hello
  class App < Wren::App
    def initialize
      @router = Hello::Router.new
      @actions = Hello::Actions.new
    end
  end
end
