# frozen_string_literal: true

require 'redis'

class PassThePopcorn
  class Redis
    @_redis = ::Redis.new(url: ENV['REDIS_URL'], db: 0)

    class << self
      def method_missing(m, *args, &block)
        @_redis.public_send(m, *args, &block)
      end
    end
  end
end
