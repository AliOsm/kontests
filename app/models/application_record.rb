require 'open-uri'
require 'time'

include ActionView::Helpers::TextHelper

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  USER_AGENT = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0'

  def self.generate_tad_url start_time
    add_target_attr('<a href="https://www.timeanddate.com/worldclock/fixedtime.html?year=%s&month=%s&day=%s&hour=%s&min=%s&sec=%s&p1=1440">%s</a>' % [start_time.year, start_time.month, start_time.day, start_time.hour, start_time.min, start_time.sec, start_time.strftime('%d/%m/%Y %H:%M:%S')])
  end

	def self.seconds_to_time seconds
    minutes, seconds = seconds.divmod(60)
    hours, minutes = minutes.divmod(60)
    days, hours = hours.divmod(24)

    if days > 0
    	ret = pluralize(days, 'day')
    	ret += ' and %02d:%02d:%02d' % [hours, minutes, seconds] if minutes + hours > 0
    else
    	ret = '%02d:%02d:%02d' % [hours, minutes, seconds]
    end

    ret
	end

  def self.add_target_attr anchor
    anchor.insert(3, 'target="_balnk"')
  end

  def self.ping_me
    open('https://kontests.net/', 'User-Agent' => USER_AGENT)
  end
end
