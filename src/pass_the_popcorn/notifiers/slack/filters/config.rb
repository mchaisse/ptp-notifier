# frozen_string_literal: true

class PassThePopcorn
  class Notifiers
    class Slack < SimpleDelegator
      class Filters
        class Config
          attr_reader :method_name, :channel_name

          private

          attr_writer :method_name, :channel_name

          def initialize(method_name, channel_name:)
            self.method_name  = method_name
            self.channel_name = channel_name
          end
        end
      end
    end
  end
end
