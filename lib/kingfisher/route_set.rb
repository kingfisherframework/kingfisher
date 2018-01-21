require "kingfisher/operation"
require "pry"

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
      @url = RouteUrl.new(url)
      @app = app
      @action = action
    end

    def match?(request)
      request.request_method.downcase.to_sym == verb && url.match?(request.path)
    end

    def call(env)
      request = Rack::Request.new(env)
      env["params"] = request.params.merge(url.params_for(request.path))
      response = app.new(env).public_send(action)

      [response.status_code, response.headers, response.body]
    end

    private
    attr_reader :verb, :url, :app, :action
  end

  class RouteUrl
    def initialize(url)
      @url = url
    end

    def match?(path)
      regex.match?(path)
    end

    def params_for(path)
      values = path.split("/")

      params_with_index.each_with_object({}) do |(param, i), params|
        params[param] = values[i]
      end
    end

    private

    def regex
      Regexp.new("\\A#{url.gsub(/\/:[^\/]+/, "\\/([^\\/]+)")}\\z")
    end

    def params_with_index
      url.
        split("/").
        each_with_index.
        select { |part, i| part.start_with?(":") }.
        map { |part, i| [part[1..-1], i] }
    end
  end
end
