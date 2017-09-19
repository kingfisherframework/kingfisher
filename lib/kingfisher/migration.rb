module Kingfisher
  class Migration
    attr_reader :version, :name

    def initialize(filename)
      @filename = filename
      migration_dir = filename.split("/", 3)[1]
      @version, @name = migration_dir.split("_", 2)
    end

    def sql
      @_sql ||= File.read(filename)
    end

    private
    attr_reader :filename
  end
end
