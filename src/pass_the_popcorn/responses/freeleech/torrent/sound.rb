# frozen_string_literal: true

class PassThePopcorn
  class Responses
    class Freeleech < SimpleDelegator
      class Torrent < SimpleDelegator
        class Sound < SimpleDelegator
          def atmos?
            __getobj__.match?('Atmos')
          end
        end
      end
    end
  end
end
