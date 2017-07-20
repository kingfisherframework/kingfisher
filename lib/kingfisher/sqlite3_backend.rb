require "sequel"

module Kingfisher
  class SqlLite3Backend
    def initialize(file)
      @db = Sequel.connect("sqlite://#{file}")
    end

    def all(model)
      db[table_name(model)].to_a
    end

    def create(model, params)
      id = db[table_name(model)].insert(params)
      attributes = symbolize_keys(params).merge(id: id)
      model.new(attributes)
    end

    def find(model, id)
      find_by(model, id: id)
    end

    def find_by(model, attributes)
      model.new(db[table_name(model)][**attributes])
    end

    private
    attr_reader :db

    def table_name(model)
      model.name.downcase.to_sym
    end

    def symbolize_keys(hash)
      hash.each_with_object({}) do |(key, value), new_hash|
        new_hash[key.to_sym] = value
      end
    end
  end
end
