module Kingfisher
  class Model
    def initialize(attributes)
      @attributes = attributes
    end

    def [](key)
      attributes[key]
    end

    private
    attr_reader :attributes
  end
end
