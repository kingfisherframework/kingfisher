module Kingfisher
  class NullRepo
    def all(_)
      []
    end
  end

  class Redirect
    DEFAULTS = {
      status_code: 302,
      body: ["You are being redirected"],
      headers: { "Content-Type" => "plain/text" }
    }
    def initialize(to:, **options)
      @path = to
      @options = DEFAULTS.merge(options)
    end

    def status_code
      options[:status_code]
    end

    def headers
      options[:headers].merge("Location" => path)
    end

    def body
      options[:body]
    end

    private
    attr_reader :path, :options
  end

  class Controller
    def initialize(env)
      @env = env
    end

    private
    attr_reader :env

    def request
      @_request ||= Rack::Request.new(env)
    end

    def view(view_class, locals: {})
      view_class.new(request, locals: locals)
    end

    def params
      request.env.fetch("params") { {} }
    end

    def redirect(path)
      Redirect.new(path)
    end
  end
end
