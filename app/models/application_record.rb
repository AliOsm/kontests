require 'open-uri'

include ActionView::Helpers::TextHelper

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  USER_AGENT = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0'

	def self.seconds_to_time seconds
    minutes, seconds = seconds.divmod(60)
    hours, minutes = minutes.divmod(60)
    days, hours = hours.divmod(24)

    if days > 0
    	ret = pluralize(days, 'day')
    	ret += ' and %02d:%02d:%02d' % [hours, minutes, seconds] if seconds + minutes + hours > 0
    else
    	ret = '%02d:%02d:%02d' % [hours, minutes, seconds]
    end

    ret
	end

  def self.add_target_attr anchor
    anchor.insert(3, 'target="_balnk"')
  end
end
