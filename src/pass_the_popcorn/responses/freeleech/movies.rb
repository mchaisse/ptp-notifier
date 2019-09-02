# frozen_string_literal: true

require_relative 'movie'

class PassThePopcorn
  class Responses
    class Freeleech < SimpleDelegator
      class Movies < SimpleDelegator
        private

        def initialize(delegators)
          super(delegators.map { |movie| Movie.new(movie) })
        end
      end
    end
  end
end
