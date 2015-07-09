# Wren

I'm very very slowly trying to build a web development framework with the following goals:

- Clear distinction between behavior and values.
- Small objects that do one thing.
- Router that can map a request to an "action" (a single-purpose "use case" object), passing in only what's needed from the request.
  No "controllers" or "viewsets" that have direct access to the entire request.
- Reveals intent: See what an app does by looking at the file tree.
  You should see "actions" for all the app's use-cases.
- Extreme testability. Support a good TDD flow.
    - Outside-in starting with use cases.
    - Favor injected dependencies and verifying behavior by passing in mocks as collaborators
      (as opposed to patching objects/imports in place).
    - Never accidentally integrate with collaborators, require they be passed in (dependency inversion)
    - No global helper methods (not even routing helpers - if you need routes, pass in a router)
- Don't use inheritence to share behavior, this is bad use of inheritence.
- Be smart about HTTP. Resources are at the top level of the router, not routes or request methods.
  See [wiki page on HTTP and REST](https://github.com/blaix/wren/wiki/HTTP-and-REST).
