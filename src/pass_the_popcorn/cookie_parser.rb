# frozen_string_literal: true

class PassThePopcorn
  class CookieParser < SimpleDelegator
    attr_reader :cookie

    private

    CFDUID_KEY  = /__cfduid=[^;]*/.freeze
    SESSION_KEY = /session=[^;]*/.freeze
    private_constant :CFDUID_KEY, :SESSION_KEY

    attr_reader :cfduid, :session
    attr_writer :cfduid, :session, :cookie

    def initialize(set_cookie)
      super(set_cookie)

      self.cfduid  = CFDUID_KEY.match(set_cookie)[0]
      self.session = SESSION_KEY.match(set_cookie)[0]
      self.cookie  = "#{cfduid}; #{session}"
    end
  end
end
