# frozen_string_literal: true

require_relative 'manager'

class PassThePopcorn
  class Notifiers
    class Slack < SimpleDelegator
      class Filters
        class Torrent < SimpleDelegator
          include Filters::Manager

          filter :is_4k,  channel_name: ENV['SLACK_FREELEECH_4K_CHANNEL']
          filter :bluray, channel_name: ENV['SLACK_FREELEECH_BD_CHANNEL']

          def is_4k
            resolution_type.is_4k?
          end

          def bluray
            codec_type.bluray?
          end
        end
      end
    end
  end
end
