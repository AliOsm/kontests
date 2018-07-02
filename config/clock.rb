require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    if job.eql?('frequent.update_codeforces')
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
		end
  end

  every(11.minute, 'frequent.update_codeforces')
  every(13.minute, 'frequent.update_codeforces_gym')
  every(17.minute, 'frequent.update_at_coder')
  every(19.minute, 'frequent.update_codechef')
  every(23.minute, 'frequent.update_a2oj')
  every(29.minute, 'frequent.update_cs_academy')
end
