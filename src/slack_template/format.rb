# frozen_string_literal: true

class SlackTemplate
  class Format
    class << self
      def bold(text)
        "*#{text}*"
      end

      def italic(text)
        "_#{text}_"
      end

      def link(text, uri)
        "<#{uri}|#{text}>"
      end

      def date(timestamp, text, fallback, link: nil)
        optional_link = link ? "^#{link}" : ''
        "<!date^#{timestamp}^#{text}#{optional_link}|#{fallback}>"
      end
    end
  end
end
