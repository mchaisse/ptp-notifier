# frozen_string_literal: true

class PassThePopcorn
  class Responses
    class Freeleech < SimpleDelegator
      class Torrent < SimpleDelegator
        class Container < SimpleDelegator
          def mkv?
            __getobj__ == 'MKV'
          end
        end
      end
    end
  end
end
