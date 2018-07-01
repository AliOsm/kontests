require 'json'
require 'time'

class Codeforces < ApplicationRecord
	self.primary_key = :id

	def to_param
		id.parametarize		
	end

	def self.update_contests
    # request codeforces api
		contests = JSON.load(open('https://codeforces.com/api/contest.list', 'User-Agent' => USER_AGENT))['result']

    # delete old contests from database
    delete_all

    # add contests
		contests.each do |contest|
      create(id: contest['id'].to_i,
             name: '<a href="https://codeforces.com/contestRegistration/%s" target="_blank">%s</a>' % [contest['id'], contest['name']],
             start_time: Time.strptime(contest['startTimeSeconds'].to_s, '%s').strftime('%b/%d/%Y %H:%M'),
             duration: seconds_to_time(contest['durationSeconds'].to_i)) if contest['phase'] == 'BEFORE'
    end
	end
end
