module Kingfisher
  module Generators
    class TouchCommand
      def initialize(file)
        @file = file
      end

      def visit(visitor)
        visitor.visit_touch(file)
      end

      private
      attr_reader :file
    end
  end
end
