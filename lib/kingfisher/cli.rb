module Kingfisher
  class Cli
    ALIASES = {
      "s" => "server",
      "g" => "generate"
    }.freeze

    def initialize(args, config:, reporter:)
      @command = args.shift # must shift or rack will use command as environment
      @args = args
      @config = config
      @reporter = reporter
    end

    def run
      case unaliased_command
      when "server" then config.server.start
      when "createdb"
        check = config.backend.ensure_exists
        puts check.result
      when "dropdb"
        check = config.backend.drop
        puts check.result
      when "rollbackdb"
        check = config.backend.rollback
        puts check.result
      when "migrate"
        require "kingfisher/migrator"
        Kingfisher::Migrator.new(config).run(reporter: reporter)
      when "generate"
        require "kingfisher/generators"
        generator_name, *gargs = args
        generator = Kingfisher::Generators::INTERNAL[generator_name].new(gargs)
        command = generator.run
        command.visit(generator.visitor)
      else
        raise "Unsupported command: #{command}, available commands: #{ALIASES.keys.join(", ")}"
      end
    end

    private
    attr_reader :config, :reporter, :command, :args

    def unaliased_command
      ALIASES.fetch(command, command)
    end
  end
end
