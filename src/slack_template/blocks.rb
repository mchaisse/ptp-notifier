# frozen_string_literal: true

class SlackTemplate
  class Blocks
    class << self
      def section
        { type: 'section' }
      end

      def context
        { type: 'context' }
      end

      def text(block)
        { text: block }
      end

      def mrkdwn(value)
        content(type: 'mrkdwn', value: value)
      end

      def mrkdwn_text(value)
        text(mrkdwn(value))
      end

      def accessory(block)
        { accessory: block }
      end

      def image_accessory(url:, alt_text:)
        accessory(image(url: url, alt_text: alt_text))
      end

      def image(url:, alt_text:)
        {
          type:      'image',
          image_url: url,
          alt_text:  alt_text
        }
      end

      def content(type:, value:)
        {
          type: type.to_s,
          text: value
        }
      end

      def fields(fields)
        {
          fields: fields
        }
      end

      def divider
        {
          type: 'divider'
        }
      end

      def elements(elements)
        {
          elements: elements
        }
      end
    end
  end
end
