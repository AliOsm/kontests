require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    if job.eql?('frequent.update_codeforces')
			Codeforces.update_contests
		end
  end

  every(30.minute, 'frequent.update_codeforces')
end
