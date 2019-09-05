require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    if job.eql?('frequent.ping')
      PingService.ping
    else
      UpdateSitesService.send(job.split('.')[-1])
    end
  end

  every(2.minute, 'frequent.all')
  every(3.minute, 'frequent.codeforces')
  every(3.minute, 'frequent.codeforces_gym')
  every(3.minute, 'frequent.at_coder')
  every(5.minute, 'frequent.code_chef')
  every(5.minute, 'frequent.a2oj')
  # every(7.minute, 'frequent.cs_academy')
  # every(11.minute, 'frequent.hacker_earth')
  every(29.minute, 'frequent.ping')
end
