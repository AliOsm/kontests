require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    case job
    when 'frequent.ping'
      PingService.ping
    when 'frequent.2_min'
      AllService.new.update_contests
    when 'frequent.3_min'
      CodeforcesService.new.update_contests
      CodeforcesGymService.new.update_contests
      TopCoderService.new.update_contests
      AtCoderService.new.update_contests
    when 'frequent.5_min'
      CodeChefService.new.update_contests
      HackerRankService.new.update_contests
      HackerEarthService.new.update_contests
      LeetCodeService.new.update_contests
    when 'frequent.7_min'
      CsAcademyService.new.update_contests
      KickStartService.new.update_contests
    end
  end

  every(3.minute, 'frequent.3_min')
  every(5.minute, 'frequent.5_min')
  every(7.minute, 'frequent.7_min')
  every(2.minute, 'frequent.2_min')
  every(29.minute, 'frequent.ping')
end
