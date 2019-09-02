# frozen_string_literal: true

require_relative 'torrent'

class PassThePopcorn
  class Responses
    class Freeleech < SimpleDelegator
      class Torrents < SimpleDelegator
        private

        def initialize(delegators)
          super(delegators.map { |torrent| Torrent.new(torrent) })
        end
      end
    end
  end
end
