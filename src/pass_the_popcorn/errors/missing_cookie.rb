# frozen_string_literal: true

class PassThePopcorn
  class MissingCookie < StandardError
    def initialize(message = 'Cookie is missing, please login first')
      super
    end
  end
end
