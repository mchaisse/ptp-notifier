# frozen_string_literal: true

require 'httparty'

require_relative 'pass_the_popcorn/cache/movies'
require_relative 'pass_the_popcorn/cookie_parser'
require_relative 'pass_the_popcorn/errors/failed_request'
require_relative 'pass_the_popcorn/errors/missing_cookie'
require_relative 'pass_the_popcorn/link_builder'
require_relative 'pass_the_popcorn/logger'
require_relative 'pass_the_popcorn/notifiers/slack'
require_relative 'pass_the_popcorn/notifiers/slack/filters'
require_relative 'pass_the_popcorn/notifiers/slack/movie'
require_relative 'pass_the_popcorn/responses/freeleech'

class PassThePopcorn
  include HTTParty

  FREELEECH_DURATION_SECS = ENV.fetch('PTP_FREELEECH_DURATION', 86400) # 24 hours
  FREELEECH_DURATION_DAYS = FREELEECH_DURATION_SECS.divmod(60*60*24)[0] # 1 day
  PTP_BASE                = ENV.fetch('PTP_BASE', 'https://passthepopcorn.me')
  FREELEECH_CHANNEL       = ENV.fetch('SLACK_FREELEECH_CHANNEL', 'freeleech')
  LOGIN_OPTS              = { keeplogged: '0', login: 'Login!' }.freeze
  private_constant :FREELEECH_CHANNEL, :LOGIN_OPTS

  base_uri PTP_BASE

  def freeleech
    Logger.info('[PTP] Freeleech starting...')

    raw_response = get_request(:freeleech)
    Logger.debug("[PTP] Freeleech raw response: #{raw_response}")

    response = Responses::Freeleech.new(raw_response)
    Logger.debug("[PTP] Freeleech parsed payload: #{response}")

    self.authkey   = response.authkey # save authkey to query the API/logout without login again
    slack_notifier = Notifiers::Slack.new

    # movies that have not been notified yet
    Cache::Movies.new(response.movies).notifiable do |movie|
      Logger.debug("[PTP] Notifying movie: #{movie}")

      freeleech_movie = Notifiers::Slack::Movie.new(movie).freeleech

      # post on the main channel
      slack_notifier.post(freeleech_movie, channel: FREELEECH_CHANNEL)

      # post on sub channels if filters are matching
      Notifiers::Slack::Filters.channels(movie).each do |channel_name|
        slack_notifier.post(freeleech_movie, channel: channel_name)
      end
    end
  end

  def login(username: ENV['PTP_USERNAME'], password: ENV['PTP_PASSWORD'],
            passkey: ENV['PTP_PASSKEY'], options: {})
    Logger.info('[PTP] Logging in...')

    opts = LOGIN_OPTS.merge(options)
    params = {
      username: username,
      password: password,
      passkey:  passkey
    }.merge(opts)

    self.passkey = passkey
    response     = Net::HTTP.post_form(LinkBuilder.uri(:login), params)

    raise FailedRequest.new(response) unless response.code_type == Net::HTTPOK
    self.cookie = CookieParser.new(response['set-cookie']).cookie

    response
  end

  def logout
    Logger.info('[PTP] Logging out...')

    # an authkey can be acquired after a GET request (e.g. #freeleech)
    unless authkey
      Logger.warn("[PTP] Could not logout, 'authkey' unknown.")
      return false
    end

    raise MissingCookie unless cookie

    response    = get_request(:logout, query: { auth: authkey })
    self.cookie = nil # clear the cookie

    response
  end

  private

  attr_reader :passkey, :authkey, :cookie
  attr_writer :passkey, :authkey, :cookie

  def get_request(service, query: {}, headers: {})
    raise MissingCookie unless cookie

    headers  = { 'Cookie' => cookie }.merge(headers)
    response = self.class.get(LinkBuilder.uri(service), query: query, headers: headers)

    raise FailedRequest.new(response) unless response.success?

    response
  end
end
