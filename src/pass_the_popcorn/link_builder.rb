# frozen_string_literal: true

require_relative '../pass_the_popcorn'

class PassThePopcorn
  class LinkBuilder
    REQUESTS = {
      login:     ENV.fetch('PTP_LOGIN_REQUEST', '/ajax.php?action=login'),
      logout:    ENV.fetch('PTP_LOGOUT_REQUEST', '/logout.php'),
      freeleech: ENV.fetch('PTP_FREELEECH_REQUEST', '/torrents.php?freetorrent=1&grouping=0&json=noredirect'),
      torrent:   ENV.fetch('PTP_TORRENT_REQUEST', '/torrents.php?id=${id}&torrentid=${torrent_id}'),
      artist:    ENV.fetch('PTP_ARTIST_REQUEST', '/artist.php?id=${id}'),
      tag:       ENV.fetch('PTP_TAG_REQUEST', '/torrents.php?taglist=${name}&cover=1')
    }.freeze
    EXTERNAL = {
      imdb: ENV.fetch('IMDB_URL', 'http://www.imdb.com/title/${id}')
    }.freeze
    private_constant :REQUESTS, :EXTERNAL

    class << self
      def torrent(id:, torrent_id: nil)
        substitute(uri(:torrent), { id: id, torrent_id: torrent_id })
      end

      def artist(id:)
        substitute(uri(:torrent), { id: id })
      end

      def tag(name:)
        substitute(uri(:torrent), { name: name })
      end

      def imdb(id:)
        substitute(EXTERNAL[:imdb].dup, { id: id })
      end

      def uri(service, base: PassThePopcorn::PTP_BASE)
        URI.join(base, REQUESTS[service.to_sym])
      end

      private

      def substitute(link, subs = {})
        subs.each_with_object(link.to_s) do |(key, value), url|
          url.sub!("${#{key.to_sym}}", value.to_s)
        end
      end
    end
  end
end
