require 'json'

class CodeforcesGym < ApplicationRecord
  self.pluralize_table_names = false
  self.primary_key = :id

  def to_param
    id.parametarize   
  end

  def self.update_contests
    # request codeforces api
    contests = JSON.load(open('http://codeforces.com/api/contest.list?gym=true'))['result']

    # delete old contests from database
    delete_all

    # add contests
    contests.each do |contest|
      create(id: contest['id'].to_i,
             name: contest['name'],
             duration: seconds_to_time(contest['durationSeconds'].to_i),
             start_time: Time.strptime(contest['startTimeSeconds'].to_s, '%s').strftime('%b/%d/%Y %H:%M')) if contest['phase'] == 'BEFORE'
    end
  end
end
