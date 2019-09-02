# frozen_string_literal: true

class PassThePopcorn
  class Responses
    class Freeleech < SimpleDelegator
      class Torrent < SimpleDelegator
        class Codec < SimpleDelegator
          def bluray?
            %w[BD25 BD50 BD100].include?(__getobj__)
          end

          def dvd?
            %w[DVD5 DVD9].include?(__getobj__)
          end
        end
      end
    end
  end
end
