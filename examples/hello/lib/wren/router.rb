module Wren
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
end
