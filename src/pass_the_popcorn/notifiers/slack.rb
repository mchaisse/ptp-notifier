# frozen_string_literal: true

require 'slack-ruby-client'

require_relative '../logger'

class PassThePopcorn
  class Notifiers
    class Slack < SimpleDelegator
      def post(notifier_obj, channel:)
        Logger.debug("[SLACK] Notifying on channel '#{channel}' object: #{notifier_obj}")
        chat_postMessage(channel: channel, **notifier_obj.message_attrs)
      end

      private

      def initialize(token: ENV['SLACK_API_TOKEN'])
        super(::Slack::Web::Client.new(token: token))
        Logger.info('[SLACK] Testing authentication')
        auth = auth_test # raise an error if connection fails
        Logger.info('[SLACK] Authentication successful')
        auth
      end
    end
  end
end
