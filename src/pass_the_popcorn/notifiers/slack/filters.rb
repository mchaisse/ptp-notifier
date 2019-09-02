# frozen_string_literal: true

require_relative 'filters/movie'
require_relative 'filters/torrent'

class PassThePopcorn
  class Notifiers
    class Slack < SimpleDelegator
      class Filters
        class << self
          def channels(movie)
            Movie.new(movie).channels.concat(Torrent.new(movie.torrent).channels)
          end
        end
      end
    end
  end
end
