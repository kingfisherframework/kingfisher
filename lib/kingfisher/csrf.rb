module Kingfisher
  class CSRF
    def initialize(request)
      @request = request
    end

    def token
      session[:csrf_token] ||= SecureRandom.base64(32)
    end

    def reset!
      session.delete(:csrf_token)
    end

    def safe?
      return true if request.get? || request.head?
      return true if request[:csrf_token] == token

      request.env["HTTP_X_CSRF_TOKEN"] == token
    end

    def unsafe?
      !safe?
    end

    def form_input
      %Q(<input type="hidden" name="csrf_token" value="#{token}">)
    end

    def meta_tag
      %Q(<meta name="csrf_token" content="#{token}">)
    end

    def session
      request.env["rack.session"]
    end

    private
    attr_reader :request
  end
end
