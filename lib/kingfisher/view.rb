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

    def render(show_layout: true)
      rendered = Slim::Template.
        new("web/templates/#{template}.slim").
        render(self)

      if show_layout
        Slim::Template.new("web/templates/layouts/#{layout}.slim").render(self) { rendered }
      else
        rendered
      end
    end

    def partial(view_class, locals: {})
      view_class.new(request, locals: locals).render(show_layout: false)
    end

    private
    attr_reader :locals, :request

    def template
      self.class.name.gsub(/View$/, "").gsub(/([a-z])([A-Z])/, '\1_\2').downcase
    end
  end
end
