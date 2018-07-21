require 'nokogiri'

class CodeChef < ApplicationRecord
  self.pluralize_table_names = false
  self.primary_key = :code

  BASE_URL = 'https://www.codechef.com'

  def to_param
    code.parametarize   
  end

  def self.update_contests
    # delete old contests from database
    delete_all
    
    # request codechef contests page
    tables = Nokogiri::HTML(open('https://www.codechef.com/contests', 'User-Agent' => USER_AGENT).read).css('.dataTable')
    tables.pop
    
    tables.each_with_index do |table, i|
      contests = table.css('tbody > tr')

      # add contests
      contests.each do |contest|
        tds = contest.css('> td')

        start_time = Time.parse(tds[2]['data-starttime']).in_time_zone('UTC')
        end_time = Time.parse(tds[3]['data-endtime']).in_time_zone('UTC')

        create(code: tds[0].text,
               name: add_target_attr(tds[1].css('a').to_s.insert(9, BASE_URL)),
               start_time: generate_tad_url(start_time),
               end_time: generate_tad_url(end_time),
               duration: seconds_to_time(end_time - start_time),
               in_24_hours: in_24_hours?(start_time),
               status: i == 0 ? 'CODING' : 'BEFORE')
      end
    end
  end
end
