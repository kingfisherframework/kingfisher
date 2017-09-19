require "kingfisher/migration"

module Kingfisher
  class NullReporter
    def report; end
  end

  class Migrator
    def initialize(config)
      @config = config
    end

    def run(reporter: NullReporter.new)
      ensure_migrations_table_exists
      run_new_migrations(reporter)
    end

    private
    attr_reader :config

    def backend
      config.backend
    end

    def run_new_migrations(reporter)
      new_migrations.each do |migration|
        reporter.report "Migrating #{migration.name}"
        backend.migrate(migration)
      end
    end

    def new_migrations
      all_migrations.
        reject { |migration| migrated.include?(migration.version) }
    end

    def all_migrations
      Dir.
        glob("migrations/**/up.sql").
        map { |file| Migration.new(file) }
    end

    def migrated
      backend.db[:__kingfisher_schema_migrations].map(:version)
    end

    def ensure_migrations_table_exists
      backend.ensure_migrations_table_exists
    end
  end
end
