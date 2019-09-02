# frozen_string_literal: true

require_relative '../cache'
require_relative '../redis/torrent'

class PassThePopcorn
  class Cache
    class Movies < SimpleDelegator
      # When Redis is empty, no torrent will be set as 'notified' which will cause all the
      # list to be sent at once. This can happen for 3 reasons:
      #   - The script is starting for the first time, therefore Redis is empty
      #   - Redis has been reset
      #   - The container has been resarted (Redis data is not persisted)
      # To prevent a flood of notifications, we will set a unique variable allowing us
      # to know that the script has been initiated at least once. During that first launch,
      # we will ignore the list and persist it in cache.
      def notifiable
        initiated          = Cache.initiated?
        processed_movies   = []
        cached_torrent_ids = Redis::Torrent.keys.to_set

        each do |movie|
          unless cached_torrent_ids.include?(movie.torrent.id.to_s)
            yield(movie) if block_given? && initiated

            processed_movies << movie
          end
        end

        # because commands are not dependent, client doesn't wait for response so it is faster
        Redis::Torrent.pipelined do
          processed_movies.each { |movie| movie.torrent.cache.notified! }
        end

        Cache.initiated! unless initiated

        Logger.debug("[PTP] No movies to nofify") if processed_movies.empty?

        processed_movies
      end
    end
  end
end
