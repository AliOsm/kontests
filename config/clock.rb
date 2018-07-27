require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    if job.eql?('frequent.update_all')
      All.update_contests
    elsif job.eql?('frequent.update_codeforces')
			Codeforces.update_contests
    elsif job.eql?('frequent.update_codeforces_gym')
      CodeforcesGym.update_contests
    elsif job.eql?('frequent.update_at_coder')
      AtCoder.update_contests
    elsif job.eql?('frequent.update_codechef')
      CodeChef.update_contests
    elsif job.eql?('frequent.update_a2oj')
      A2oj.update_contests
    elsif job.eql?('frequent.update_cs_academy')
      CsAcademy.update_contests
    elsif job.eql?('frequent.ping_me')
      ApplicationRecord.ping_me
    end
  end

  every(1.minute, 'frequent.update_all')
  every(3.minute, 'frequent.update_codeforces')
  every(3.minute, 'frequent.update_codeforces_gym')
  every(3.minute, 'frequent.update_at_coder')
  every(5.minute, 'frequent.update_codechef')
  every(5.minute, 'frequent.update_a2oj')
  every(7.minute, 'frequent.update_cs_academy')
  every(29.minute, 'frequent.ping_me')
end
