require "wren/router"
require "hello/app"

module Hello
  class Router < Wren::Router
    def initialize
      super do
        resource "hello", at: "/hello" do
          on "GET", call: "say_hello"
          on "HEAD", call: "do_nothing"
        end

        resource "world", at: "/world" do
          on "DELETE", call: "say_goodbye"
        end
      end
    end
  end
end
