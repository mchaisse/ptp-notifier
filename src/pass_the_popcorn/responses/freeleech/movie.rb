# frozen_string_literal: true

require 'htmlentities'

require_relative '../../logger'
require_relative '../../omdb_api'
require_relative 'directors'
require_relative 'torrents'

class PassThePopcorn
  class Responses
    class Freeleech < SimpleDelegator
      class Movie < SimpleDelegator
        attr_reader :group_id, :title, :year, :cover, :tags, :directors, :imdb_id, :total_leechers,
                    :total_seeders, :total_snatched, :max_size, :last_uploaded_time,
                    :torrents

        def full_imdb_id
          "tt#{imdb_id}"
        end

        def imdb_rating
          omdb_object.try(:imdb_rating)
        end

        def omdb_object
          Logger.debug("[OMDB] Getting Omdb info for IMDB id: #{full_imdb_id}")
          self.saved_omdb_object ||= OmdbApi.find_by_id(full_imdb_id)
          Logger.debug("[OMDB] Got object: #{saved_omdb_object}")
          saved_omdb_object
        end

        def torrent
          torrents.first
        end

        protected

        attr_reader :saved_omdb_object

        private

        attr_writer :group_id, :title, :year, :cover, :tags, :directors, :imdb_id, :total_leechers,
                    :total_seeders, :total_snatched, :max_size, :last_uploaded_time,
                    :torrents, :saved_omdb_object

        def initialize(data)
          super(data)

          self.group_id           = self['GroupId']
          self.title              = HTMLEntities.new.decode(self['Title'])
          self.year               = self['Year']
          self.cover              = self['Cover']
          self.tags               = self['Tags']
          self.directors          = Directors.new(self.fetch('Directors', []))
          self.imdb_id            = self['ImdbId']
          self.total_leechers     = self['TotalLeechers']
          self.total_seeders      = self['TotalSeeders']
          self.total_snatched     = self['TotalSnatched']
          self.max_size           = self['MaxSize']
          self.last_uploaded_time = self['LastUploadTime']
          self.torrents           = Torrents.new(self.fetch('Torrents', []))
        end
      end
    end
  end
end
