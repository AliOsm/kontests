require 'open-uri'
require 'json'
require 'time'

include ActionView::Helpers::TextHelper

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

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
end
