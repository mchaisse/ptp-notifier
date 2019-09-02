# frozen_string_literal: true

require 'omdb/api'

class PassThePopcorn
  class OmdbApi
    @_client = Omdb::Api::Client.new(api_key: ENV['OMDB_API_KEY'])

    class << self
      def method_missing(m, *args, &block)
        @_client.public_send(m, *args, &block)
      end
    end
  end
end
