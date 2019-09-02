# frozen_string_literal: true

require_relative '../common_utils'
require_relative '../../../link_builder'
require_relative 'torrent'

class PassThePopcorn
  class Notifiers
    class Slack < SimpleDelegator
      class Freeleech
        class Movie < SimpleDelegator
          include CommonUtils

          def message_title
            @message_title ||= "[Freeleech] #{title} [#{torrent.resolution}]"
          end

          def message_payload
            @message_payload ||= [
              to_info,
              st_b.divider,
              to_release,
              st_b.divider,
              to_timer
            ]
          end

          def message_attrs
            @message_attrs ||= {
              text:   message_title,
              blocks: JSON.dump(message_payload)
            }
          end

          private

          attr_reader :slack_torrent
          attr_writer :slack_torrent

          def initialize(delegator)
            super(delegator)

            self.slack_torrent = Torrent.new(torrent)
          end

          def to_info
            st_b.section
                .merge!(st_b.mrkdwn_text("#{title_formatter} [#{year_formatter}] by #{directors_formatter}"))
                .merge!(st_b.image_accessory(url: cover, alt_text: title))
                .merge!(st_b.fields([rating_formatter, tags_formatter]))
          end

          def to_release
            st_b.section
                .merge!(st_b.mrkdwn_text(release_formatter))
                .merge!(st_b.fields(details_formatter))
          end

          def to_timer
            st_b.context
                .merge!(st_b.elements(timer_formatter))
          end

          def title_formatter
            st_f.link(st_f.bold(title), LinkBuilder.torrent(id: group_id))
          end

          def year_formatter
            st_f.bold(year)
          end

          def directors_formatter
            directors.map do |director|
              st_f.link(st_f.bold(director.name), LinkBuilder.artist(id: director.id))
            end.join(', ')
          end

          def rating_formatter
            rating_title = st_f.bold('Ratings')
            imdb_rat     = "#{st_f.link(st_f.bold('IMDB'), LinkBuilder.imdb(id: full_imdb_id))}: #{imdb_rating || '?'}"

            st_b.mrkdwn("#{rating_title}\n#{imdb_rat}")
          end

          def tags_formatter
            tags_title = st_f.bold('Tags')
            tags_links = tags.map do |tag_name|
                           st_f.link("_#{tag_name}_", LinkBuilder.tag(name: tag_name))
                         end.join(', ')

            st_b.mrkdwn("#{tags_title}\n#{tags_links}")
          end

          def release_formatter
            slack_torrent.title_formatter(group_id: group_id)
          end

          def details_formatter
            slack_torrent.details_formatter
          end

          def timer_formatter
            slack_torrent.timer_formatter
          end
        end
      end
    end
  end
end
