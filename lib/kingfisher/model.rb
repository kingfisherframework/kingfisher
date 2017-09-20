module Kingfisher
  class Model
    def initialize(attributes)
      @attributes = {}
      attributes.each { |key, value| @attributes[key.to_sym] = value }
    end

    def [](key)
      attributes[key.to_sym]
    end

    private
    attr_reader :attributes
  end
end
