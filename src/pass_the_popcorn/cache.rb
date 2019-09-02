# frozen_string_literal: true

require_relative 'logger'
require_relative 'redis'

class PassThePopcorn
  class Cache
    INITIATED_VAR = 'initiated'
    private_constant :INITIATED_VAR

    class << self
      def initiated!
        Logger.info('[REDIS] Initiating cache')
        Redis.set(INITIATED_VAR, true)
      end

      def initiated?
        exists = Redis.exists(INITIATED_VAR)
        Logger.info("[REDIS] Cache initiated: #{exists}")
        exists
      end
    end
  end
end
