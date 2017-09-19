require "kingfisher/operation"

module Kingfisher
  class RouteSet
    def initialize
      @routes = []
    end

    def match(request)
      mroute = @routes.find { |route| route.match?(request) }
      Operation.either(->(_){ raise NoRouteError, "#{request.request_method} #{request.path}" }, mroute).result
    end

    def get(url, controller, action)
      @routes << Route.new(:get, url, controller, action)
    end

    def post(url, controller, action)
      @routes << Route.new(:post, url, controller, action)
    end

    def delete(url, controller, action)
      @routes << Route.new(:delete, url, controller, action)
    end
  end

  class Route
    def initialize(verb, url, app, action)
      @verb = verb
      @url = url
      @app = app
      @action = action
    end

    def match?(request)
      request.request_method.downcase.to_sym == verb && request.path == url
    end

    def call(env)
      response = app.new(env).public_send(action)
      [response.status_code, response.headers, response.body]
    end

    private
    attr_reader :verb, :url, :app, :action
  end

end
