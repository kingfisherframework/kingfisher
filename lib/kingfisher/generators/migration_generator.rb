require "kingfisher/generators/base_generator"
require "kingfisher/generators/visitors/base_visitor"

module Kingfisher
  module Generators
    class MigrationGenerator < BaseGenerator
      def initialize(args)
        @args = args
      end

      def run
        compose([
          mkdir("migrations"),
          mkdir(migration_dir),
          make_migrations
        ])
      end

      def visitor
        BaseVisitor.new
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
        compose([
          touch("#{migration_dir}/up.sql"),
          touch("#{migration_dir}/down.sql")
        ])
      end
    end
  end
end
