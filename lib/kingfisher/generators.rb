require "fileutils"

module Kingfisher
  module Generators
    class BaseGenerator
      include FileUtils
    end

    class MigrationGenerator < BaseGenerator
      def initialize(args)
        @args = args
      end

      def run
        mkdir_p migration_dir
        make_migrations
      end

      private
      attr_reader :args

      def migration_name
        args[0]
      end

      def get_timestamp
        Time.now.strftime("%Y%m%d%H%M%S")
      end

      def migration_dir
        @_migration_dir ||= "migrations/#{get_timestamp}_#{migration_name}"
      end

      def make_migrations
        touch "#{migration_dir}/up.sql"
        touch "#{migration_dir}/down.sql"
      end
    end

    INTERNAL = {
      "migration" => MigrationGenerator
    }.freeze
  end
end
