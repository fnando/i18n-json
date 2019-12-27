# frozen_string_literal: true

module I18nJSON
  class CLI
    class ExportCommand < Command
      command_name "export"
      description "Export translations as JSON files"

      parse do |opts|
        opts.banner = "Usage: i18n-json #{name} [options]"

        opts.on(
          "-cCONFIG_FILE",
          "--config=CONFIG_FILE",
          "The configuration file that will be generated"
        ) do |config_file|
          options[:config_file] = config_file
        end

        opts.on(
          "-rREQUIRE_FILE",
          "--require=REQUIRE_FILE",
          "A Ruby file that must be loaded"
        ) do |require_file|
          options[:require_file] = require_file
        end

        opts.on("-h", "--help", "Prints this help") do
          ui.exit_with opts.to_s
        end
      end

      command do
        config_file = File.expand_path(options[:config_file])

        if options[:require_file]
          require_file = File.expand_path(options[:require_file])
        end

        unless File.file?(config_file)
          ui.fail_with("ERROR: config file doesn't exist at #{config_file}")
        end

        if require_file && !File.file?(require_file)
          ui.fail_with("ERROR: require file doesn't exist at #{require_file}")
        end

        require_without_warnings(require_file) if require_file
        I18nJSON.call(config_file: config_file)
      end

      private def require_without_warnings(path)
        old_verbose = $VERBOSE
        $VERBOSE = nil

        require path
      ensure
        $VERBOSE = old_verbose
      end
    end
  end
end
