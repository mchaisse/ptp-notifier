# frozen_string_literal: true

require 'htmlentities'

class PassThePopcorn
  class Responses
    class Freeleech < SimpleDelegator
      class Director < SimpleDelegator
        attr_reader :name, :id

        private

        attr_writer :name, :id

        def initialize(data)
          super(data)

          self.name = HTMLEntities.new.decode(self['Name'])
          self.id   = self['Id']
        end
      end
    end
  end
end
