# frozen_string_literal: true

class PassThePopcorn
  class FailedRequest < StandardError
    attr_reader :response

    private

    attr_writer :response

    def initialize(response)
     super("Request failed: #{response.message} - #{response.body}")
     self.response = response
    end
  end
end
