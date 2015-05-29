# Wren

A framework for building large, maintainable ruby web applications using lots
of small, focused, decoupled objects sending messages to each other.

## The router

The router maps requests to actions and responders.

```ruby
require "wren/router"

class Router
  extend Wren::Router

  resource "hello", at: "/hello/%{name}" do
    on GET, call: "say_hello", with: "name", then: "render_text"
  end
end
```

`say_hello` is the name of an action. `name` is an attribute of the request and
it will be passed to the action. `render_text` is the responder and it will
receive the result of the action and return an HTTP response.

## Actions

All the work of your application happens in action objects. An action object
can be any object that responds to `call` (this means your action could even
be a simple lambda).

For example:

```ruby
class SayHello
  def call(name: "World")
    "Hello #{name}!"
  end
end
```

(More realistic examples of action objects might be `CreatePost`,
`DeleteComment`, `GetDashboard`, etc.)

Wren doesn't try to figure out where your actions live, what they're named, or
how to initialize them. It expects a factory object that has that
responsibility.  The `call:` arguments in your router should match methods on
your actions factory:

```ruby
require "actions/say_hello"

class Actions
  def say_hello
    SayHello.new
  end
end
```

## Responders

Responders have a `call` method that accepts a `response` object and the result
of an action. It should return an HTTP response (usually by calling a method
on the `response` object). For example:

```ruby
class RenderText
  def call(response, text)
    response.text(text)
  end
end
```

`response` has other methods that can do things like render a template based
on the request format (TODO), but here we're forcing a text response.

Wren expects a responders factories as well:

```ruby
require "responders/render_text"

class Responders
  def render_text
    RenderText.new
  end
end
```

## Tying it all together

Here's a full app example:

```ruby
class Actions
  def say_hello
    SayHello.new
  end

  class SayHello
    def call(name:)
      return "Hello, #{name}!"
    end
  end
end

class Responders
  def render_text
    RenderText.new
  end

  class RenderText
    def call(response, text)
      response.text(text)
    end
  end
end

class Router
  extend Wren::Router

  resource "hello", at: "/hello/%{name}" do
    on GET, call: "say_hello", with: "name", then: "render_text"
  end
end

actions = Actions.new
responders = Responders.new
router = Router.new

app = Wren::App.new(actions: actions, responders: responders, router: router)

# app is a callable rack application that you can run via config.ru:
run app
```

## TODO: 

1. Finish working example of above Hello World app.
2. Need to flesh out these thoughts:
  * "What about controllers?"
    * Explain controller frustrations
    * Responsibility of router.
  * "This seems like overkill / over-abstraction"
    * Simple example vs complex app
    * Looking at file system and seeing what an app does
    * SRP. Testability. Maintainability.
    * Bad fit for basic CRUD?
  * Why Factories?
    * Dependency injection
    * Explicitness
    * Responsibility/knowledge for loading and initializing objects (not a router
      responsibility)
    * File layout agnostic
  * Handling failures / Routing exceptions
  * Testability / Design
    * Outside-in TDD: feature == action
    * Small focused objects sending messages to each other
    * Injected dependencies
    * Explicit requires
    * No global helper methods (e.g. if you need to generate URL paths, you must
      explicitly pass in an instance of the router)
  * What about everything else? 
    * Models/Persistence
    * Views/Templates
    * Forms/Validators
