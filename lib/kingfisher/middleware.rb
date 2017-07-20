module Kingfisher
  class Middleware
    attr_reader :klass, :args, :block
    def initialize(klass, args, block)
      @klass = klass
      @args = args
      @block = block
    end
  end

  class MiddlewareStack
    def initialize
      @middlewares = []
    end

    def each
      middlewares.each { |x| yield x }
    end

    def use(klass, *args, &block)
      middlewares.push(Middleware.new(klass, args, block))
    end

    private
    attr_reader :middlewares
  end
end
