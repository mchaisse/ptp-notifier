# frozen_string_literal: true

require_relative 'freeleech/movies'

class PassThePopcorn
  class Responses
    class Freeleech < SimpleDelegator
      attr_reader :authkey, :passkey, :response, :movies

      private

      attr_writer :authkey, :passkey, :response, :movies

      def initialize(response)
        super(response)

        self.response = parsed_response
        self.movies   = Movies.new(response.fetch('Movies', []))
        self.authkey  = response['AuthKey']
        self.passkey  = response['PassKey']
      end
    end
  end
end
