# frozen_string_literal: true

require "test_helper"

class ExportCommandTest < Minitest::Test
  let(:stdout) { StringIO.new }
  let(:stderr) { StringIO.new }

  test "displays help" do
    cli = I18nJSON::CLI.new(
      argv: %w[export --help],
      stdout: stdout,
      stderr: stderr
    )

    assert_exit_code(0) { cli.call }
    assert_stdout_includes "Usage: i18n-json export [options]"
  end

  test "with missing file" do
    config_file = "missing/i18n-json.yml"

    cli = I18nJSON::CLI.new(
      argv: %W[export --config #{config_file}],
      stdout: stdout,
      stderr: stderr
    )

    assert_exit_code(1) { cli.call }
    assert_stderr_includes \
      "ERROR: config file doesn't exist at #{File.expand_path(config_file)}"
  end

  test "with missing require file" do
    require_file = "missing/require.rb"

    cli = I18nJSON::CLI.new(
      argv: %W[
        export
        --config test/config/everything.yml
        --require #{require_file}
      ],
      stdout: stdout,
      stderr: stderr
    )

    assert_exit_code(1) { cli.call }
    assert_stderr_includes \
      "ERROR: require file doesn't exist at #{File.expand_path(require_file)}"
  end

  test "with existing file" do
    I18n.load_path << Dir["./test/fixtures/yml/*.yml"]

    cli = I18nJSON::CLI.new(
      argv: %w[export --config test/config/everything.yml],
      stdout: stdout,
      stderr: stderr
    )

    assert_exit_code(0) { cli.call }

    assert_file "test/output/everything.json"
    assert_json_file "test/fixtures/expected/everything.json",
                     "test/output/everything.json"
  end

  test "requires file" do
    cli = I18nJSON::CLI.new(
      argv: %w[
        export
        --config test/config/everything.yml
        --require test/config/require.rb
      ],
      stdout: stdout,
      stderr: stderr
    )

    assert_exit_code(0) { cli.call }

    assert_file "test/output/everything.json"
    assert_json_file "test/fixtures/expected/everything.json",
                     "test/output/everything.json"
  end
end
