# frozen_string_literal: true

require_relative '../logger'
require_relative '../redis/torrent'
require_relative '../../pass_the_popcorn'

class PassThePopcorn
  class Cache
    class Torrent < SimpleDelegator
      def notified!
        Logger.debug("[REDIS] Setting torrent id #{id} as notified for #{PassThePopcorn::FREELEECH_DURATION_SECS} seconds")
        Redis::Torrent.setex(id, PassThePopcorn::FREELEECH_DURATION_SECS, true)
      end

      def notified?
        Redis::Torrent.exists(id)
      end
    end
  end
end
