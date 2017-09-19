module Kingfisher
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
