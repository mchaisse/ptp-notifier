# frozen_string_literal: true

require 'time'

require_relative '../../cache/torrent'
require_relative '../../../filesize'
require_relative '../../../pass_the_popcorn'
require_relative 'torrent/codec'
require_relative 'torrent/container'
require_relative 'torrent/encode'
require_relative 'torrent/resolution'
require_relative 'torrent/sound'
require_relative 'torrent/video'

class PassThePopcorn
  class Responses
    class Freeleech < SimpleDelegator # Base
      class Torrent < SimpleDelegator
        attr_reader :id, :quality, :source, :container, :codec, :resolution, :scene, :size,
                    :upload_time, :remaster_title, :snatched, :seeders, :leechers, :release_name,
                    :release_group, :checked, :golden_popcorn, :freeleech_type, :cache,
                    :codec_type, :resolution_type, :container_type, :sound_type, :video_type,
                    :encode_type

        def release_title
          title = remaster_title || (scene ? 'Scene' : nil)

          [codec, container, source, resolution, title].compact.join(' / ')
        end

        def readable_size
          Filesize.readable(size.to_i)
        end

        def upload_datetime
          DateTime.parse(upload_time)
        end

        def freeleech_end_datetime
          upload_datetime + PassThePopcorn::FREELEECH_DURATION_DAYS
        end

        def upload_timestamp
          upload_datetime.to_time.to_i
        end

        def freeleech_end_timestamp
          Time.now.to_i + PassThePopcorn::FREELEECH_DURATION_SECS
        end

        private

        attr_writer :id, :quality, :source, :container, :codec, :resolution, :scene, :size,
                    :upload_time, :remaster_title, :snatched, :seeders, :leechers, :release_name,
                    :release_group, :checked, :golden_popcorn, :freeleech_type, :cache,
                    :codec_type, :resolution_type, :container_type, :sound_type, :video_type,
                    :encode_type

        def initialize(data)
          super(data)

          self.id             = self['Id']
          self.quality        = self['Quality']
          self.source         = self['Source']
          self.container      = self['Container']
          self.codec          = self['Codec']
          self.resolution     = self['Resolution']
          self.scene          = self['Scene']
          self.size           = self['Size']
          self.upload_time    = self['UploadTime']
          self.remaster_title = self['RemasterTitle']
          self.snatched       = self['Snatched']
          self.seeders        = self['Seeders']
          self.leechers       = self['Leechers']
          self.release_name   = self['ReleaseName']
          self.release_group  = self['ReleaseGroup']
          self.checked        = self['Checked']
          self.golden_popcorn = self['GoldenPopcorn']
          self.freeleech_type = self['FreeleechType']

          self.codec_type      = Codec.new(codec)
          self.resolution_type = Resolution.new(resolution)
          self.container_type  = Container.new(container)
          self.sound_type      = Sound.new(remaster_title)
          self.video_type      = Video.new(remaster_title)
          self.encode_type     = Encode.new(remaster_title)
          self.cache           = Cache::Torrent.new(self)
        end
      end
    end
  end
end
