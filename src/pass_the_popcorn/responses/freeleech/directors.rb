# frozen_string_literal: true

require_relative 'director'

class PassThePopcorn
  class Responses
    class Freeleech < SimpleDelegator
      class Directors < SimpleDelegator
        private

        def initialize(delegators)
          super(delegators.map { |director| Director.new(director) })
        end
      end
    end
  end
end
