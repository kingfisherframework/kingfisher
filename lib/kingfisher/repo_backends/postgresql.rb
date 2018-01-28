require "sequel"
require "kingfisher/operation"
require "kingfisher/migration"

module Kingfisher
  module RepoBackends
    class PostgreSQL
      attr_reader :db

      def initialize(database_url:)
        @database_url = database_url
        @connected = false
        @db = open_db
      end

      def migrate(migration)
        execute migration.up_sql
        schema_migrations.insert(version: migration.version)
      end

      def rollback
        migration = last_migration
        execute migration.down_sql
        schema_migrations.where(version: migration.version).delete
        Success.new("Rolled back #{migration.name}")
      end

      def execute(sql)
        db.execute(sql)
      end

      def table_exists?(name)
        db.table_exists?(name)
      end

      def connected?
        @connected
      end

      def migrated
        schema_migrations.map(:version)
      end

      def drop
        if connected?
          db.disconnect
        end
        database_operation "DROP DATABASE #{database_name}"
        Success.new("dropped database #{database_name}")
      end

      def ensure_migrations_table_exists
      if !table_exists?("__kingfisher_schema_migrations")
        execute <<-SQL
          CREATE TABLE "__kingfisher_schema_migrations" (
            version VARCHAR NOT NULL,
            run_on TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
          )
        SQL
      end
      end

      def ensure_exists
        if connected?
          db.test_connection
          Success.new("#{database_name} exists")
        else
          database_operation "CREATE DATABASE #{database_name}"
          Success.new("creating database #{database_name}")
        end
      rescue Exception => e
        Failure.new(e.to_s)
      end

      def all(model)
        db[table_name(model)].all
      end

      def assoc(parent, child_model)
        fk = foreign_key(parent.class)
        db[table_name(child_model)].where(fk => id(parent)).map do |record|
          child_model.new(record)
        end
      end

      def id(model)
        model["id"]
      end

      def foreign_key(model)
        "#{table_name(model)}_id".to_sym
      end

      def where(model, conditions)
        db[table_name(model)].where(conditions).map do |record|
          model.new(record)
        end
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
      attr_reader :database_url

      def schema_migrations
        db[:__kingfisher_schema_migrations]
      end

      def uri
        @_uri ||= URI.parse(database_url)
      end

      def last_migration
        version = schema_migrations.order(Sequel.desc(:run_on)).map(:version).first
        name = Dir.glob("migrations/#{version}*").first
        Migration.new(name)
      end

      def database_name
        uri.path[1..-1]
      end

      def database_operation(sql)
        tmp_uri = uri
        tmp_uri.path = "/postgres"
        Sequel.connect(tmp_uri.to_s) do |db|
          db.execute sql
        end
      end

      def open_db
        @connected = true
        Sequel.connect database_url
      rescue Sequel::DatabaseConnectionError
        @connected = false
        NullConnection.new
      end

      def table_name(model)
        model.name.downcase.to_sym
      end

      def symbolize_keys(hash)
        hash.each_with_object({}) do |(key, value), new_hash|
          new_hash[key.to_sym] = value
        end
      end

      class NullConnection
      end
    end
  end
end
