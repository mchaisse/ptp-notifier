# frozen_string_literal: true

require 'logger'

class PassThePopcorn
  class Logger
    FILE_PATH = '/var/log/ptp-notifier.log'
    private_constant :FILE_PATH

    @_logger= ::Logger.new(FILE_PATH)

    class << self
      # debug will not print unless "developer mode" is activated
      def debug(*attributes)
        super if ENV['DEVELOPER_MODE']
      end

      def method_missing(m, *args, &block)
        @_logger.public_send(m, *args, &block)
      end
    end
  end
end
