module Kingfisher
  module Middlewares
    class FileLogger
      def initialize(app, args)
        @app = app
        @filename = args[:file]
      end

      def call(env)
        app.call(env).tap do |response|
          log(response.inspect)
        end
      end

      private
      attr_reader :app, :filename

      def log(message)
        File.open(filename, "a+") { |file| file.puts message }
      end
    end
  end
end
