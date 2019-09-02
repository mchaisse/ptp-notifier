# frozen_string_literal: true

class PassThePopcorn
  class Responses
    class Freeleech < SimpleDelegator
      class Torrent < SimpleDelegator
        class Encode < SimpleDelegator
          def remux?
            __getobj__.match?('Remux')
          end
        end
      end
    end
  end
end
