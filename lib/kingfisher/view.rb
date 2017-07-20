require "slim"

module Kingfisher
  class View
    def initialize(request, locals: {})
      @request = request
      @locals = locals
    end

    def status_code
      @_status_code ||= 200
    end

    def headers
      @_headers ||= { "Content-Type" => "text/html" }
    end

    def body
      [render]
    end

    def render
      Slim::Template.
        new("web/templates/#{template}.slim").
        render(self)
    end

    private
    attr_reader :locals, :request

    def template
      self.class.name.gsub(/View$/, "").gsub(/([a-z])([A-Z])/, '\1_\2').downcase
    end
  end
end
