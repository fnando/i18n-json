# frozen_string_literal: true

module I18nJSON
  class CLI
    class UI
      def initialize(stdout:, stderr:)
        @stdout = stdout
        @stderr = stderr
      end

      def stdout_print(message)
        @stdout << "#{message}\n"
      end

      def stderr_print(message)
        @stderr << "#{message}\n"
      end

      def fail_with(message)
        stderr_print(message)
        exit(1)
      end

      def exit_with(message)
        stdout_print(message)
        exit(0)
      end
    end
  end
end
