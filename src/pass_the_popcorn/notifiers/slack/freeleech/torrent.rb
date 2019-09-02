# frozen_string_literal: true

require_relative '../common_utils'
require_relative '../../../link_builder'

class PassThePopcorn
  class Notifiers
    class Slack < SimpleDelegator
      class Freeleech
        class Torrent < SimpleDelegator
          include CommonUtils

          def title_formatter(group_id:)
            icon          = golden_popcorn ? ':sunny:' : (checked ? ':white_check_mark:' : nil)
            torrent_title = "#{release_title} / #{st_f.bold('Freeleech')}"
            torrent_link  = st_f.link(torrent_title, LinkBuilder.torrent(id: group_id, torrent_id: id))
            r_name        = "#{st_f.bold('Release name:')} #{release_name}"

            "#{icon} #{torrent_link}\n#{r_name}"
          end

          def details_formatter
            [
              st_b.mrkdwn("#{st_f.bold('Size:')} #{readable_size}"),
              st_b.mrkdwn(":arrows_clockwise: #{snatched}"),
              st_b.mrkdwn(":arrow_up: #{seeders}"),
              st_b.mrkdwn(":arrow_down: #{leechers}")
            ]
          end

          def timer_formatter
            text       = '{date_long} {time}'
            start_time = st_f.date(upload_timestamp, text, upload_datetime.rfc2822)
            end_time   = st_f.date(freeleech_end_timestamp, text, freeleech_end_datetime.rfc2822)

            [
              st_b.mrkdwn("#{st_f.bold('Upload Time:')} #{start_time}"),
              st_b.mrkdwn("#{st_f.bold('End Time:')} ~ #{end_time}")
            ]
          end
        end
      end
    end
  end
end
