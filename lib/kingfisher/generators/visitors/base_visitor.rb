require "fileutils"

module Kingfisher
  module Generators
    class BaseVisitor
      include FileUtils
      def visit_mkdir(dir)
        return if Dir.exists?(dir)
        mkdir dir
      end

      def visit_touch(file)
        touch file
      end

      def visit_list(commands)
        commands.each do |command|
          command.visit(self)
        end
      end
    end
  end
end
