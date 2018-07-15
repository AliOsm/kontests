require 'json'

class CodeforcesGym < ApplicationRecord
  self.pluralize_table_names = false
  self.primary_key = :code

  def to_param
    code.parametarize   
  end

  def self.update_contests
    # request codeforces api
    contests = JSON.load(open('https://codeforces.com/api/contest.list?gym=true', 'User-Agent' => USER_AGENT))['result']

    # delete old contests from database
    delete_all

    # add contests
    contests.reverse.each do |contest|
      start_time = contest['startTimeSeconds'].to_s.blank? ? '-' : Time.strptime(contest['startTimeSeconds'].to_s, '%s')
      
      create(code: contest['id'].to_i,
             name: '<a href="https://codeforces.com/gymRegistration/%s" target="_blank">%s</a>' % [contest['id'], contest['name']],
             start_time: start_time.eql?('-') ? start_time : generate_tad_url(start_time),
             duration: seconds_to_time(contest['durationSeconds'].to_i),
             difficulty: contest['difficulty'].to_i,
             in_24_hours: start_time.eql?('-') ? start_time : in_24_hours?(start_time),
             status: contest['phase']) if contest['phase'] == 'BEFORE' || contest['phase'] == 'CODING'
    end
  end
end
