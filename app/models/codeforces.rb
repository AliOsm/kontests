class Codeforces < ApplicationRecord
	self.primary_key = :id

	def to_param
		id.parametarize		
	end

	def self.update
		# delete old contests from database
		self.delete_all

		# add regular contests
		contests = JSON.load(open('http://codeforces.com/api/contest.list'))['result']
		add_future_contests(contests, 0)

		# add gym contests
		contests = JSON.load(open('http://codeforces.com/api/contest.list?gym=true'))['result']
		self.add_future_contests(contests, 1)
	end

	private

	def self.add_future_contests contests, category
		contests.each do |contest|
		  self.create(id: contest['id'].to_i,
		    					name: contest['name'],
		    					duration: self.seconds_to_time(contest['durationSeconds'].to_i),
		    					start_time: Time.strptime(contest['startTimeSeconds'].to_s, '%s').strftime('%b/%d/%Y %H:%M'),
		    					category: category) if contest['phase'] == 'BEFORE'
		end
	end
end
