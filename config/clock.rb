require 'clockwork'

module Clockwork
  handler do |job|
    if job.eql?('something')
			# do somthing
		end
  end

  every(1.minute, 'something')
end
