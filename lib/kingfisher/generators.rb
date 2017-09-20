require "kingfisher/generators/migration_generator"

module Kingfisher
  module Generators
    INTERNAL = {
      "migration" => MigrationGenerator
    }.freeze
  end
end
