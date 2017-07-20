require "sequel"

module Kingfisher
  module DatabaseBackends
    class PostgreSQL
      def initialize(database_url:)
        @database_url = database_url
        @db = open_db
      end

      def all(model)
        db[table_name(model)].all
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
        db[table_name(model)][**attributes]
      end

      private
      attr_reader :db, :database_url

      def open_db
        Sequel.connect database_url
      end

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
end
