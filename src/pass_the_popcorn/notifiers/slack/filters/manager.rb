# frozen_string_literal: true

require_relative 'config'

class PassThePopcorn
  class Notifiers
    class Slack < SimpleDelegator
      class Filters
        module Manager
          def self.included(base)
            base.extend(ClassMethods)
            base.instance_variable_set(:@_filters, [])
          end

          module ClassMethods
            def filter(*attributes)
              @_filters << Config.new(*attributes)
            end
          end

          def filters
            self.class.instance_variable_get(:@_filters)
          end

          def channels
            filters.map do |config|
              config.channel_name if public_send(config.method_name)
            end.compact
          end
        end
      end
    end
  end
end
