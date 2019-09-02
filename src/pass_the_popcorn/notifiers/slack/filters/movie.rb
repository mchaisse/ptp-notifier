# frozen_string_literal: true

require_relative 'manager'

class PassThePopcorn
  class Notifiers
    class Slack < SimpleDelegator
      class Filters
        class Movie < SimpleDelegator
          include Filters::Manager
        end
      end
    end
  end
end
