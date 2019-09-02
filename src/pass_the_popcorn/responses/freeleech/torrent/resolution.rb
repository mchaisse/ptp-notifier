# frozen_string_literal: true

class PassThePopcorn
  class Responses
    class Freeleech < SimpleDelegator
      class Torrent < SimpleDelegator
        class Resolution < SimpleDelegator
          def is_2k?
            __getobj__ == '1080p'
          end

          def is_4k?
            __getobj__ == '2160p'
          end
        end
      end
    end
  end
end
