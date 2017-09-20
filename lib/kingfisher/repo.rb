module Kingfisher
  class Repo
    def initialize(backend)
      @backend = backend
    end

    def all(model)
      backend.all(model)
    end

    def find(model, id)
      backend.find(model, id)
    end

    def where(model, conditions)
      backend.where(model, conditions)
    end

    def create(model, params)
      backend.create(model, params)
    end

    def find_by(model, attributes)
      backend.find_by(model, attributes)
    end

    private
    attr_reader :backend
  end
end
