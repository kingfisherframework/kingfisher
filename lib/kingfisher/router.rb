module Kingfisher
  NoRouteError = Class.new(StandardError)

  class Router
    def call(env)
      request = Rack::Request.new(env)

      if csrf(request).unsafe?
        forbidden
      else
        route(request).call(env)
      end
    end

    private

    def route_set
      @_route_set ||= RouteSet.new
    end

    def route(request)
      route_set.match(request)
    end

    def get(url, controller, action)
      route_set.get(url, controller, action)
    end

    def post(url, controller, action)
      route_set.post(url, controller, action)
    end

    def delete(url, controller, action)
      route_set.delete(url, controller, action)
    end

    def forbidden
      [403, {"Content-Type" => "text/plain"}, ["Forbidden"]]
    end

    def csrf(request)
      @_csrf ||= CSRF.new(request)
    end
  end
end
