require 'json'

class Codeforces < ApplicationRecord
	self.primary_key = :code

	def to_param
		code.parametarize		
	end

	def self.update_contests
    # request codeforces api
		contests = JSON.load(open('https://codeforces.com/api/contest.list', 'User-Agent' => USER_AGENT))['result']

    # delete old contests from database
    delete_all

    # add contests
		contests.reverse.each do |contest|
		  start_time = Time.strptime(contest['startTimeSeconds'].to_s, '%s')
		  
      create(code: contest['id'].to_i,
             name: '<a href="https://codeforces.com/contestRegistration/%s" target="_blank">%s</a>' % [contest['id'], contest['name']],
             start_time: generate_tad_url(start_time),
             duration: seconds_to_time(contest['durationSeconds'].to_i),
             in_24_hours: in_24_hours?(start_time)) if contest['phase'] == 'BEFORE'
    end
	end
end
