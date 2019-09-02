# frozen_string_literal: true

require_relative 'freeleech/movie'

class PassThePopcorn
  class Notifiers
    class Slack < SimpleDelegator
      class Movie < SimpleDelegator
        def freeleech
          Freeleech::Movie.new(__getobj__)
        end
      end
    end
  end
end
