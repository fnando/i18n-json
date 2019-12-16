# frozen_string_literal: true

module I18nJSON
  class CLI
    class InitCommand < Command
      command_name "init"
      description "Initialize a project"

      parse do |opts|
        opts.banner = "Usage: i18n-json #{name} [options]"

        opts.on(
          "-cCONFIG_FILE",
          "--config=CONFIG_FILE",
          "The configuration file that will be generated"
        ) do |config_file|
          options[:config_file] = config_file
        end

        opts.on("-h", "--help", "Prints this help") do
          ui.exit_with opts.to_s
        end
      end

      command do
        file_path = File.expand_path(options[:config_file])

        if File.file?(file_path)
          ui.fail_with("ERROR: #{file_path} already exists!")
        end

        FileUtils.mkdir_p(File.dirname(file_path))

        File.open(file_path, "w") do |file|
          file << <<~YAML
            ---
            translations:
              - file: some/dir/locale.json
                patterns:
                  - "*"
                  - "!*.activerecord"

          YAML
        end
      end
    end
  end
end
