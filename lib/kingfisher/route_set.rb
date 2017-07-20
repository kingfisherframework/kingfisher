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

  module Operation
    def self.either(failure, maybe)
      if maybe.nil?
        Failure.new(failure)
      else
        Success.new(maybe)
      end
    end
  end

  class Failure
    attr_reader :failure
    def initialize(failure)
      @failure = failure
    end

    def result
      @failure
    end

    def success?
      false
    end
  end

  class Success
    attr_reader :success
    def initialize(success)
      @success = success
    end

    def result
      @success
    end

    def success?
      true
    end
  end
end
