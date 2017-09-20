module Kingfisher
  module Generators
    class MkdirCommand
      def initialize(dir)
        @dir = dir
      end

      def visit(visitor)
        visitor.visit_mkdir(dir)
      end

      private
      attr_reader :dir
    end
  end
end
