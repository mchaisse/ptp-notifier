# frozen_string_literal: true

require_relative '../../../slack_template/blocks'
require_relative '../../../slack_template/format'

class PassThePopcorn
  class Notifiers
    class Slack < SimpleDelegator
      class Freeleech
        module CommonUtils
          private

          def st_b
            SlackTemplate::Blocks
          end

          def st_f
            SlackTemplate::Format
          end
        end
      end
    end
  end
end
