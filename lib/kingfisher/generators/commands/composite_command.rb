module Kingfisher
  module Generators
    class CompositeCommand
      def initialize(commands)
        @commands = commands
      end

      def visit(visitor)
        visitor.visit_list(commands)
      end

      private
      attr_reader :commands
    end
  end
end
