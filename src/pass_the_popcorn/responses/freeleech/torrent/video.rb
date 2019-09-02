# frozen_string_literal: true

class PassThePopcorn
  class Responses
    class Freeleech < SimpleDelegator
      class Torrent < SimpleDelegator
        class Video < SimpleDelegator
          def hdr10?
            __getobj__.match?('HDR10')
          end
        end
      end
    end
  end
end
