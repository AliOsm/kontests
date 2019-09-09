require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    if job.eql?('frequent.ping')
      PingService.ping
    elsif job.eql?('frequent.cf_cfg_ac')
      UpdateSitesService.codeforces
      UpdateSitesService.codeforces_gym
      UpdateSitesService.at_coder
    elsif job.eql?('frequent.cc_a2')
      UpdateSitesService.code_chef
      UpdateSitesService.a2oj
    elsif job.eql?('frequent.lc_csa_he')
      UpdateSitesService.leet_code
      UpdateSitesService.cs_academy
      UpdateSitesService.hacker_earth
    else
      UpdateSitesService.send(job.split('.')[-1])
    end
  end

  every(3.minute, 'frequent.cf_cfg_ac') # codeforces, codeforces_gym, at_coder
  every(5.minute, 'frequent.cc_a2') # code_chef, a2oj
  every(7.minute, 'frequent.lc_csa_he') # leet_code, cs_academy, hacker_earth
  every(2.minute, 'frequent.all')
  every(29.minute, 'frequent.ping')
end
