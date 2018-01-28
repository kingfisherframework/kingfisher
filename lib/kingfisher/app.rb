module Kingfisher
  class App
    def initialize(router, config)
      @router = router
      @config = config
      @builder = Rack::Builder.new

      config.middlewares.each do |middleware|
        builder.use middleware.klass, *middleware.args, &middleware.block
      end

      builder.run(router)

      run_initializers
    end

    def call(env)
      request = Rack::Request.new(env)
      request.env["dependencies"] = dependencies

      builder.call(env)
    end

    private
    attr_reader :builder, :router, :config

    def dependencies
      config.dependencies
    end

    def root
      config.root
    end

    def repo
      @_repo ||= config.repo.new(config.backend)
    end

    def run_initializers
      Dir.glob("#{root}/config/initializers/*.rb").each do |file|
        require file
      end
    end
  end
end
