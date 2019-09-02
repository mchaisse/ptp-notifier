# frozen_string_literal: true

require 'redis'

require_relative '../redis'

class PassThePopcorn
  class Redis
    class Torrent < Redis
      # overwrite db number so we can isolate the torrent cache
      @_redis = ::Redis.new(url: ENV['REDIS_URL'], db: 1)
    end
  end
end
