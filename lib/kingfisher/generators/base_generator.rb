require "kingfisher/generators/commands/mkdir_command"
require "kingfisher/generators/commands/touch_command"
require "kingfisher/generators/commands/composite_command"

module Kingfisher
  module Generators
    class BaseGenerator
      def mkdir(dir)
        MkdirCommand.new(dir)
      end

      def touch(file)
        TouchCommand.new(file)
      end

      def compose(commands)
        CompositeCommand.new(commands)
      end
    end
  end
end
