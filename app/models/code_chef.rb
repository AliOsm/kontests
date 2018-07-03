require 'nokogiri'

class CodeChef < ApplicationRecord
  self.pluralize_table_names = false
  self.primary_key = :code

  BASE_URL = 'https://www.codechef.com'

  def to_param
    code.parametarize   
  end

  def self.update_contests
    # request codechef contests page
    contests = Nokogiri::HTML(open('https://www.codechef.com/contests', 'User-Agent' => USER_AGENT).read).css('.dataTable')[1].css('tbody > tr')

    # delete old contests from database
    delete_all

    # add contests
    contests.each do |contest|
      tds = contest.css('> td')

      start_time = Time.parse(tds[2]['data-starttime']).in_time_zone('UTC')
      end_time = Time.parse(tds[3]['data-endtime']).in_time_zone('UTC')

      create(code: tds[0].text,
             name: add_target_attr(tds[1].css('a').to_s.insert(9, BASE_URL)),
             start_time: generate_tad_url(start_time, start_time.strftime('%d/%m/%Y %H:%M:%S')),
             end_time: generate_tad_url(end_time, end_time.strftime('%d/%m/%Y %H:%M:%S')),
             duration: seconds_to_time(end_time - start_time))
    end
  end
end
