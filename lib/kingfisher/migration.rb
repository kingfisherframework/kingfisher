module Kingfisher
  class Migration
    attr_reader :version, :name

    def initialize(dir)
      @dir = dir
      migration_dir = dir.split("/", 2).last
      @version, @name = migration_dir.split("_", 2)
    end

    def up_sql
      @_up_sql ||= File.read("#{dir}/up.sql")
    end

    def down_sql
      @_down_sql ||= File.read("#{dir}/down.sql")
    end

    private
    attr_reader :dir
  end
end
